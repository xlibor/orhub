
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()
local ParseDown = lx.use('.app.lxhub.markdown.parseDown')

function _M:new()

    local this = {
        htmlParser = nil,
        markdownParser = nil
    }
    
    return oo(this, mt)
end

function _M:ctor()

    -- self.htmlParser = new('htmlConverter', {header_style = 'atx'})
    self.markdownParser = new(ParseDown)
end

function _M:convertHtmlToMarkdown(html)

    return self.htmlParser:convert(html)
end

function _M:convertMarkdownToHtml(markdown, clean)

    clean = lf.needTrue(clean)
    local convertedHtml = self.markdownParser:text(markdown)
    -- if clean then
    --     convertedHtml = clean(convertedHtml, 'user_comment_content')
    -- end
    convertedHtml = str.gsub(convertedHtml, '<pre><code>', '<pre><code class=" language-lua">')
    
    return convertedHtml

    -- local convertedHtml = self.markdownParser:setBreaksEnabled(true):text(markdown)
    -- convertedHtml = Purifier.clean(convertedHtml, 'user_topic_body')
    -- convertedHtml = str.replace(convertedHtml, "<pre><code>", '<pre><code class=" language-php">')
    
    -- return convertedHtml
end

return _M

