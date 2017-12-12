
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str, new = lx.kit()
local fs, use               = lx.fs, lx.use
 
local Markdown              = use('.app.core.markdown.markdown')
local TopicDoer             = use('.app.http.doer.topic')
local User                  = use('.app.model.user')
local Blog                  = use('.app.model.blog')

local slug_trans            = Ah.slug_trans
local Html2md               = require(".app.core.markdown.html2md")
local sfind, ssub, sgsub    = string.find, string.sub, string.gsub
local regsub                = str.regsub

function _M:ctor()

    self.csvDir = '/vagrant/res/google-groups/'
    self.slugPrefix = 'google-groups-'
    self.topics = {}
end

function _M:run()

    local csvPath = self.csvDir .. 'data.csv'

    local csv, headers = app('csv'):parseFile(csvPath, 
        {
            rename = {
                ['topic-link-href'] = 'href',
                ['topic-link'] = 'title',
                ['topic-content'] = 'content'
            }
        }
    )
 
    for i, topic in ipairs(csv) do
 
        echo(i, '  ', topic.title)
        -- if sfind(topic.title, '用Nginx记日志') then
        --     self:createTopic(topic)
        --     break
        -- end
        self:createTopic(topic)

        echo('====================')
 
    end
end

function _M.__:cleanup()

end

function _M.__:createTopic(data)

    local user = self:getUser()
    local title = data.title

    local href = data.href
    local slug = self.slugPrefix .. slug_trans(title)
    local html = data.content

    local topicAuthor, replies = self:parseTopicInfo(html)

    if not topicAuthor then return end

    local md = self:generateMd(topicAuthor, replies)

    local data = {
        title = title,
        slug = slug,
        body = md,
        category_id = 9,
        tags = nil
    }

    return new(TopicDoer):create(self, user, data, false)
end

function _M.__:parseTopicInfo(html)

    html = self:preFilter(html)
    -- lx.fs.put(lx.dir('tmp', 'app') .. 'some.html', html)

    local dom = new('domDocument'):loadHtml(html)
    
    -- do return end

    -- dom = dom:removedBy('.F0XO1GC-Db-b')
    --         :removedBy('.F0XO1GC-Db-a')

    local rows = dom:find("div.F0XO1GC-nb-W[tabindex]")
    local topicAuthor, replier, replyTime, replyText
    local nodes
    local replies = {}

    for _, row in ipairs(rows) do
        nodes = row(".F0XO1GC-D-a")
        if #nodes > 0 then
            replier = nodes[1].textContent
            if not topicAuthor then
                topicAuthor = replier
            end
        end

        nodes = row(".F0XO1GC-nb-Q")
        if #nodes > 0 then
            replyTime = nodes[1].title
        end

        nodes = row("span.F0XO1GC-nb-fb[role='gridcell']")
        if #nodes > 0 then
            replyText = nodes[1]:getText()
        end
 
        nodes = row("div.F0XO1GC-nb-P[tabindex]")
        if #nodes > 0 then
            local tryNodes = row("div[dir='ltr']")
            if #tryNodes > 0 then
                nodes = tryNodes
            end
            replyText = nodes[1]:getText()
        end
        
        if replyText then
            replyText = self:filterReplyHtml(replyText)
        end

        if replyTime then
            local pat = [[(\d+)年(\d+)月(\d+)日.+UTC\+8(.+)(\d+):(\d+):(\d+)]]
            local m = str.rematch(replyTime, pat)

            local year, month, day, halfday, hour, minute, sec = 
                unpack(m)
            if halfday == '下午' then
                hour = tonumber(hour) + 12
            end
            replyTime = year .. '-' .. month .. '-' .. day .. ' ' ..
                hour .. ':' .. minute .. ':' .. sec
        else
            replyTime = 'unknown'
        end

        tapd(replies, {
            replier = replier,
            replyTime = replyTime,
            replyText = replyText or 'unknown'
        })
        replyText = nil
        replyTime = nil
    end

    return topicAuthor, replies
end

function _M.__:preFilter(html)

    html = self:removeDiv(html, 'F0XO1GC-Db-a')
    html = self:removeDiv(html, 'F0XO1GC-Db-b')

    html = regsub(html, [[<blockquote class="gmail_quote"[\s\S]*?</blockquote>]], '')
    html = sgsub(html, [[邮件来自列表.-agentzh%-nginx%-tutorials%-zhcn%.<wbr>html</a>]],
            '')
    -- html = sgsub(html, [[>([^'<]-'[^'<]-)<]], '> %1<')
    html = sgsub(html, '>', '> ')
    html = sgsub(html, ">'", "> '")
    html = sgsub(html, '>"', '> "')
    html = sgsub(html, '<wbr>', '')
    html = sgsub(html, '<wbr .->', '')
    html = sgsub(html, "<br.->", "<br />")
    html = sgsub(html, [[src="(data:image/.-)"]], '')

    return html
end

function _M.__:removeDiv(html, className)

    while true do
        local firstPos = sfind(html, "<div [^>]-" .. str.quote(className))
        if not firstPos then break end
        local over = str.findTagEnd(html, 'div', _, firstPos + 3)
        if not over then break end
        html = ssub(html, 1, firstPos - 1) .. ssub(html, over + 1)
    end

    return html
end

function _M.__:filterReplyHtml(html)
    
    html = sgsub(html, '> ', '>')
    html = sgsub(html, "<code>(.-)</code>", function(m)
        m = sgsub(m, '&nbsp;', ' ')
        m = sgsub(m, [[<span style="white%-space:pre">(%s*)</span>]],
            "%1")
        return "  \n\n```lua  \n" .. m .. "  \n```\n"
    end)
    html = sgsub(html, "<div.->(.-)</div>", "%1  \n")
    html = sgsub(html, "<br />", '  \n')
    html = sgsub(html, "<[^>]*>", '')
    html = sgsub(html, "\n  \n", '  \n')

    return html
end

function _M.__:generateMd(topicAuthor, replies)

    local md = {}
    -- tapd(md, '### 发帖人:' .. topicAuthor)

    for i, reply in ipairs(replies) do
        tapd(md, '## 作者: ' .. reply.replier ..
            ', ' .. reply.replyTime)

        tapd(md, reply.replyText)
        tapd(md, '\n-----')
    end

    return str.join(md, '\n')
end

function _M.__:getUser()

    return User.find(1)
end

function _M:creatorSucceed(topic)

    self.topics[topic.slug] = topic
end


return _M

