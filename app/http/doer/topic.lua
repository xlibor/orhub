
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()
local use                   = lx.use
local Markdown              = use('.app.core.markdown.markdown')
local Notifier              = use('.app.core.notification.notifier')
local UserPublishedNewTopic = use('.app.activity.userPublishedNewTopic')
local BlogHasNewArticle     = use('.app.activity.blogHasNewArticle')
local StaticTopic           = use('.app.model.topic')
local Doc                   = require('lxlib.dom.base.xmlDoc')

local get_platform, slug_trans = Ah.get_platform, Ah.slug_trans
local tconcat = table.concat

function _M:new()

    local this = {
        mentionParser = new '.app.core.notification.mention'
    }
    
    return oo(this, mt)
end

function _M:create(observer, data, blog)

    -- 检查是否重复发布
    if self:isDuplicate(data) then
        
        return observer:creatorFailed('请不要发布重复内容。')
    end
    data.user_id = Auth.id()
    local currTime = lf.datetime()
    data.created_at = currTime
    data.updated_at = currTime

    data.body = self.mentionParser:parse(data.body)
    local markdown = new(Markdown)
    data.body_original = data.body
    data.body = markdown:convertMarkdownToHtml(data.body)

    data.excerpt = StaticTopic.makeExcerpt(data.body)
    data.source = get_platform()
    data.slug = slug_trans(data.title)
    data.category_id = tonumber(data.category_id)
    
    local topic = Topic.create(data)
    if not topic then
        
        return observer:creatorFailed(topic:getErrors())
    end
    if blog then
        blog:topics():attach(topic.id)

        if not blog:authors():where('user_id', topic.user_id):exists() then
            blog:authors():attach(topic.user_id)
        end
    end
    if topic.is_draft ~= 'yes' and topic.category_id ~= app:conf('lxhub.adminBoardCid') then
        new(Notifier):newTopicNotify(Auth.user(), self.mentionParser, topic)
        new(UserPublishedNewTopic):generate(Auth.user(), topic)
    end

    if topic:isArticle() and topic.is_draft == 'yes' then
        Auth.user():increment('draft_count', 1)
    elseif topic:isArticle() then
        Auth.user():increment('article_count', 1)
        blog:increment('article_count', 1)
        new(BlogHasNewArticle):generate(Auth.user(), topic, topic:blogs():first())
    else
        Auth.user():increment('topic_count', 1)
    end

    topic:collectImages()
    
    return observer:creatorSucceed(topic)
end

function _M:update(request, observer, data, topic)

    local mentionParser = self.mentionParser
    data.body = mentionParser:parse(data.body)
    local markdown = new(Markdown)
    data.body_original = data.body
    data.body = markdown:convertMarkdownToHtml(data.body)
    local body, summary = self:parseTopicSummary(data.body)
    data.body = body
    data.summary = tostring(summary)

    data.excerpt = StaticTopic.makeExcerpt(data.body)
    if topic:isArticle() and request.subject == 'publish' and topic.is_draft == 'yes' then
        data.is_draft = 'no'
        -- Topic Published
        app(Notifier):newTopicNotify(Auth.user(), mentionParser, topic)
        -- User activity
        app(UserPublishedNewTopic):generate(Auth.user(), topic)
        app(BlogHasNewArticle):generate(Auth.user(), topic, topic:blogs():first())
        Auth.user():decrement('draft_count', 1)
        Auth.user():increment('article_count', 1)
    end
    
    topic:update(data)
    topic:collectImages()

    return observer:creatorSucceed(topic)
end

function _M:parseTopicSummary(html)

    local index = 0
    local tagLevel = 1
    local rootUl = Doc.new('ul', {id="topicSummary", class = 'list'})
    local wrap = rootUl
    local wrapParent
    local li, tl, text, ul
    local pat = [[<a name="(.+)"><\/a>\n<h([123]+)>(.+)<\/h]]

    html = str.regsub(html, pat, function(m)
        index = index + 1
        tl, text = m[2], m[3]
 
        if index == 1 or tl == tagLevel then
            wrap:addtag('li', {class = ''}):addtag('a', {href = '#topicHeader' .. index})
            :text(text):up()
        elseif tl > tagLevel then
            wrap = wrap:addtag('ul', {class = 'list'}):addtag('li'):addtag('a', {href = '#topicHeader' .. index})
            :text(text):up():up():last()
        elseif tl < tagLevel then
            if tl == 1 then
                wrap:addtag('li', {class = ''}):addtag('a', {href = '#topicHeader' .. index})
                    :text(text):up()
                wrap = rootUl
            else
                wrapParent = wrap.parent or wrap
                wrapParent:up():addtag('li', {class = ''})
                :addtag('a', {href = '#topicHeader' .. index})
                    :text(text):up()
                wrap = wrapParent
            end
        end

        tagLevel = tl

        return '<a name="topicHeader' .. index .. '"></a>\n<h' ..
            tl .. '>' .. text .. '</h'
    end)

    return html, rootUl
end

function _M:isDuplicate(data)

    local last_topic = Topic.where('user_id', Auth.id()):orderBy('id', 'desc'):first()
    
    return last_topic and lf.eq(last_topic.title, data.title)
end

return _M

