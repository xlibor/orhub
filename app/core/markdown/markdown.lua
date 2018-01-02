
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()

local Doc           = require('lxlib.dom.base.xmlDoc')
local sgsub, sfind  = string.gsub, string.find


function _M:new()

    local this = {
    }
    
    return oo(this, mt)
end

function _M:ctor()

end

function _M:convertHtmlToMarkdown(html)

end

function _M:convertMarkdownToHtml(markdown, clean)

    clean = lf.needTrue(clean)

    local convertedHtml = app('markdown'):md2html(markdown)

    convertedHtml = str.gsub(convertedHtml, '<code class="(%w+)">', '<code class=" language-%1">')
    convertedHtml = str.gsub(convertedHtml, '<pre><code>', '<pre><code class=" language-lua">')

    return convertedHtml
end

function _M:parseTopicSummary(html)

    local index = 0
    local tagLevel = 1
    local rootUl = Doc.new('ul', {id="topicSummary", class = 'topicSummary'})
    local wrap = rootUl
    local wrapParent
    local li, tl, text, pureText, ul
    local pat = [[<a name="(.+)"><\/a>\n<h([12345]+)>(.+)<\/h]]

    html = str.regsub(html, pat, function(m)
        index = index + 1
        tl, text = m[2], m[3]
        pureText = text
        text = sgsub(text, "<[^>]->", '')
        text = sgsub(text, "&hellip;", "...")
        
        if index == 1 or tl == tagLevel then
            wrap:addtag('li' ):addtag('a', {href = '#topicHeader' .. index})
            :text(text):up()
        elseif tl > tagLevel then
            wrap = wrap:addtag('ul', {class = 'topicSummary'}):addtag('li'):addtag('a', {href = '#topicHeader' .. index})
            :text(text):up():up():last()
        elseif tl < tagLevel then
            if tl == 1 then
                wrap:addtag('li'):addtag('a', {href = '#topicHeader' .. index})
                    :text(text):up()
                wrap = rootUl
            else
                wrapParent = wrap.parent or wrap
                wrapParent:up():addtag('li')
                :addtag('a', {href = '#topicHeader' .. index})
                    :text(text):up()
                wrap = wrapParent
            end
        end

        tagLevel = tl

        return '<a name="topicHeader' .. index .. '"></a>\n<h' ..
            tl .. '>' .. pureText .. '</h'
    end)

    return html, rootUl
end

function _M:parseBlogSummary(html, articles)

    html = self:convertMarkdownToHtml(html)

    local pat = [[(\(aid:(\d+)\))]]
    html = str.regsub(html, pat, function(m)
        local aid = m[2]
        local article = articles:find(aid)
        if article then
            return '<a href="/articles/' .. aid .. '/' ..
                article.slug .. '">' .. article.title ..
                '</a>'
        else
            return m[1]
        end
    end)

    return html
end

return _M

