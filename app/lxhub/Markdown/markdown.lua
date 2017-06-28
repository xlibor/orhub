
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        htmlParser = nil,
        markdownParser = nil
    }
    
    return oo(this, mt)
end

function _M:ctor()

    self.htmlParser = new('htmlConverter', {header_style = 'atx'})
    self.markdownParser = new('parsedown')
end

function _M:convertHtmlToMarkdown(html)

    return self.htmlParser:convert(html)
end

function _M:convertMarkdownToHtml(markdown)

    local convertedHmtl = self.markdownParser:setBreaksEnabled(true):text(markdown)
    convertedHmtl = Purifier.clean(convertedHmtl, 'user_topic_body')
    convertedHmtl = str.replace(convertedHmtl, "<pre><code>", '<pre><code class=" language-php">')
    
    return convertedHmtl
end

return _M

