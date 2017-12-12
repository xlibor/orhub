

local html2md = {}

-- Load html from a file
function html2md.loadFile(filename)
    local f = assert(io.open(filename, "r"), "No such file: " .. filename) -- Check file exists
    local html = f:read("*all")
    f:close()
    return html
end

function html2md.findLinkRoot(html)
     -- We capture the opening quote 'or " to make sure we close with the same type
    local _, linkRoot = html:match("<base .- href%=([\"\'])(%w)%1")
    return linkRoot or ""
end

-- Substitute the special markdown characters
function html2md.escapeHTML(html)
    html = html:gsub("`", "'")      -- Backtick for quote
    html = html:gsub("*", "&#42;")  -- Asterisk for html escape code
    html = html:gsub("_", "&#95;")  -- Underscore for html escape code
    html = html:gsub("~~", "&#126;&#126;") -- Double tildes for html escape codes
    return html
end

function html2md.removeNewlines(html) --TODO: not in ``` blocks
    html = html:gsub('(%a)\r?\n', '%1 ') -- Space is there to prevent words running together which were split by \n
    html = html:gsub("\r?\n", "")
    return html
end

function html2md.fixTagWhitespace(html)
    html = html:gsub("< ", "<")
    -- Add a space before the closing tag to ease tag matching below
    html = html:gsub(">", " >")
    return html
end

function html2md.tagsToLowercase(html)
    html = html:gsub("%b<>", string.lower)
    return html
end

-- Longer matches first!
function html2md.replaceTags(html)
    html = html:gsub("<h%d .->", "\n\n#")   -- Header -- TODO: Differentiate between h1, h2 etc.
    html = html:gsub("</h%d >", "\n========\n") -- Header close
    html = html:gsub("<big .->", "\n###")   -- Big text
    html = html:gsub("<br /?>", "\n")       -- Linebreak
    -- This will add 2 newlines for each p tag *and* each closing p tag.
    html = html:gsub("</?p .->", "\n\n")    -- Paragraph
    html = html:gsub("</?section .->", "\n") -- Section
    html = html:gsub("</?article .->", "\n\n")  -- Article
    html = html:gsub("</?main .->", "********") -- Main body
    html = html:gsub("</?em .->", "*")      -- Emphasis -- TODO: May not work when spanning linebreaks
    html = html:gsub("</?i .->", "_")       -- Italics
    html = html:gsub("</?b .->", "**")      -- Bold
    html = html:gsub("</?u .->", "__")      -- Underline
    html = html:gsub("</?cite .->", "_")    -- Citation (italicise)
    html = html:gsub("</?dfn .->", "_") -- Definition (italicise)
    html = html:gsub("</?del .->", "~~")    -- Strikethrough (deleted)
    html = html:gsub("</?s .->", "~~")      -- Strikethrough (changed)
    html = html:gsub("</?strike .->", "~~")-- Strikethrough (again!)
    html = html:gsub("</?mark .->", "__")   -- Marked text
    html = html:gsub("</?code .->", "`")    -- Inline code
    html = html:gsub("</?samp .->", "`")    -- Inline code sample
    html = html:gsub("</?tt .->", "'")      -- Teletype text (inline code)
    html = html:gsub("</?pre .->", "\n```\n")   -- Pre-formatted text block (code) -- TODO: Preserve whitespace in pre blocks
    html = html:gsub("</?kbd .->", "`") -- Keyboard input
    html = html:gsub("<hr /?.->", "\n--------\n")   -- Horizontal rule
    html = html:gsub("</?q .->", "\"")      -- Inline quote
    html = html:gsub("<aside .->", "\n\t(") -- Aside (block)
    html = html:gsub("</aside.- >", ")\n")  -- Aside close
    html = html:gsub("<script .-</script .->", "") -- Remove scripts
    html = html:gsub("<svg .-</svg .->", "")    -- Remove SVG elements
    html = html:gsub("<!%-%-.-%-%- >", "")  -- Remove comments
    html = html:gsub("<style .-</style .->", "")    -- Remove style blocks
    html = html:gsub("  +", " ")        -- Remove excess whitespace
    html = html:gsub("\t", "")
    return html
end

-- TODO: Find a string (alt-text etc.) for links with no text
function html2md.replaceLinks(html, hide_urls, linkRoot)
    if not hide_urls then
         -- Quote is not used, it's just to pair quotemarks in the capture
        html = html:gsub("<a .-href=([\"\'])(.-)%1.- >(.-)</a >", function(quote, url, text)
            if url:sub(1,1) == "/" or url:sub(1,1) == "." then url = linkRoot..url end
            return "["..text.."]".."("..url..")"
        end)
    else
        html = html:gsub("<a .->(.-)</a >", "[%1]")
    end
    return html
end

function html2md.replaceImages(html, hide_urls)

    html = html:gsub("<img (.-src=([\"\'])(.-)%2.-)>", function(attributes, quote, src)
            local _, altText = attributes:match("alt=([\"\'])(.-)%1")
            local imageString
            if not hide_urls then
                if altText then imageString = "!["..altText.."]("..src..")"
                else imageString = "!["..src:match("(%w-).%w-$").."]("..src..")" -- Filename (without extension)
                end
            else
                if altText then imageString = "![ IMAGE: "..altText.."]"
                else imageString = "![ IMAGE: "..src:match("(%w-).%w-$").."]"
                end
            end
            return imageString
        end)
    return html
end

function html2md.replaceBlockQuote(html)
    html = html:gsub("<blockquote .->.-\n.-</blockquote .->",
        function(q) return q:gsub("\n","\n> ")end ) -- Quotes _inide_ blockquote tags
    html = html:gsub("<blockquote .->", "\n> ") -- Replace first tag, closing tag will be removed later.
    return html
end

function html2md.replaceTables(html)
    local i, j, tableString, headerString = 0, 0, "", "" -- i is used as a cursor as we move through the string
    while true do
        i, j, tableString = html:find("<table .->(.-)</table .->", i)
        if i == nil then break end
        local tableString, headerCells = tableString:gsub("<th .->", "|")
        if headerCells == nil then
            local topRow = tableString:match("<tr .->.-</tr .->")
            for _ in topRow:gmatch("<td .->") do
                headerCells = headerCells + 1
            end
        end
        for c=1, headerCells do
            headerString = headerString .. "| ---"
        end
        -- Insert the header string after the first table row
        tableString = tableString:gsub("</tr .->", headerString, 1)
        tableString = tableString:gsub("<td .->", " | ")
        tableString = tableString:gsub("</tr .->", "\n")
        html = html:sub(1, i-1) .. tableString .. html:sub(j+1, -1)
    end
    return html
end

function html2md.findNextListOpening(html, cursor)
    local nextUl = html:find("<ul .->", cursor) or #html
    local nextOl = html:find("<ol .->", cursor) or #html
    local nextDl = html:find("<dl .->", cursor) or #html
    return math.min(nextUl, nextOl, nextDl)
end

function html2md.findNextListClose(html, cursor)
    local nextul = html:find("</ul .->", cursor) or #html
    local nextol = html:find("</ol .->", cursor) or #html
    local nextdl = html:find("</dl .->", cursor) or #html
    return math.min(nextul, nextol, nextdl)
end

function html2md.replaceListBlock(block, depth, listType)
    depth = depth or 0
    -- Add an indent before the line if we're in a nested list
    local depthIndent = ""
    for i=1, depth do depthIndent = "  " .. depthIndent end -- Adds 2 spaces for every level of nesting

    -- If block is an ordered list, replace <'li'> with 1, 2, 3
    if listType == "ol" then
        local olMarker =  1
        while true do
            local liStart, liEnd = block:find("<li .->")
            if liStart == nil or liEnd > #block then break end
            block = block:sub(1, liStart-1).."\n"..depthIndent..tostring(olMarker)..". "..block:sub(liEnd+1, -1)
            olMarker = olMarker + 1
        end
        -- If block is a description list, format it nicely
    elseif listType == "dl" then
        block = block:gsub("<dt .->", "\n"..depthIndent.."**")
        block = block:gsub("</dt .->", "**")
        block = block:gsub("<dd .->", "\n"..depthIndent.."  _")
        block = block:gsub("</dd .->", "_")
        -- Else block is either an unordered list or something has gone wrong,
                -- either way we replace <'li'> with *
                else
            block = block:gsub("<li .->", "\n" .. depthIndent .. "* ")
        end

    -- Remove all the leftover closing tags
    block = block:gsub("</li .->", "")
    block = block:gsub("</dt .->", "")
    block = block:gsub("<ul .->", "")
    block = block:gsub("<ol .->", "")
    block = block:gsub("<dl .->", "")
    block = block:gsub("</ul .->", "\n")
    block = block:gsub("</ol .->", "\n")
    block = block:gsub("</dl .->", "\n")
    return block
end

function html2md.replaceLists(html)
    local cursor, depth, listStack = 1, 0, {}
    while true do
        if cursor == nil or cursor >= #html then break end

        -- The current block stretches from the cursor to the nearest list tag
        local nextListOpen = html2md.findNextListOpening(html, cursor + 1)
        local nextListClose = html2md.findNextListClose(html, cursor + 1)
        local blockEnd = math.min(nextListOpen, nextListClose)

        -- Substitute <'li'>s in the block for the right type of md list prefix
        -- The type of list is stored on the listStack
        local block = html:sub(cursor, blockEnd-1)
        if depth > 0 then -- depth < 1 suggests we are not in a list block
            html = html:sub(1, cursor-1) .. html2md.replaceListBlock(block, depth, listStack[#listStack]) .. html:sub(blockEnd, -1)
        end

        -- Move the cursor to the end of this block
        if nextListOpen < nextListClose then
            -- Next block starts with a deeper nested list
            cursor = html2md.findNextListOpening(html, cursor + 1)
            depth = depth + 1
            -- Add the list type to the stack("ul" "ol" or "dl")
            table.insert(listStack, html:sub(cursor + 1, cursor + 2))
        else
            -- This list block ends and we go shallower or not a list
            cursor = html2md.findNextListClose(html, cursor + 1)
            depth = math.max(depth-1, 0)
            -- Remove the list type from the stack
            table.remove(listStack, #listStack)
        end
    end
    return html
end

function html2md.stripTags(html)
    html = html:gsub("%b<>", "")
    return html
end

function html2md.parse(html, hide_urls)
    local linkRoot = html2md.findLinkRoot(html)
    html = html2md.escapeHTML(html)
    html = html2md.fixTagWhitespace(html)
    html = html2md.tagsToLowercase(html)
    html = html2md.removeNewlines(html)
    html = html2md.replaceTags(html)
    html = html2md.replaceLinks(html, hide_urls, linkRoot)
    html = html2md.replaceImages(html, hide_urls)
    html = html2md.replaceBlockQuote(html)
    html = html2md.replaceTables(html)
    html = html2md.replaceLists(html)
    html = html2md.stripTags(html)
    return html
end

function html2md.parsefile(filename, hide_urls)
    local html = tostring(html2md.loadFile(filename))
    local md = html2md.parse(html, hide_urls)
    return md
end

return html2md