
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

local get_platform, slug_trans = Ah.get_platform, Ah.slug_trans
local tconcat               = table.concat

function _M:new()

    local this = {
        mentionParser = new '.app.core.notification.mention'
    }
    
    return oo(this, mt)
end

function _M:create(observer, user, data, socialize, blog)

    -- 检查是否重复发布
    if self:isDuplicate(data, user) then
        return observer:creatorFailed('请不要发布重复内容。')
    end
 
    self:saveData(data, user, true)
    local topic = Topic.create(data)
    if not topic then
        return observer:creatorFailed(topic:getErrors())
    end

    local tags = data.tags
    if tags then
        topic:tag(tags)
    end
    
    if blog then
        blog:topics():attach(topic.id)
        if not blog:authors():where('user_id', topic.user_id):exists() then
            blog:authors():attach(topic.user_id)
        end
    end

    if socialize and topic.is_draft ~= 'yes' and topic.category_id ~= app:conf('lxhub.adminBoardCid') then
        new(Notifier):newTopicNotify(user, self.mentionParser, topic)
        new(UserPublishedNewTopic):generate(user, topic)
    end

    if topic:isArticle() and topic.is_draft == 'yes' then
        user:increment('draft_count', 1)
    elseif topic:isArticle() then
        user:increment('article_count', 1)
        blog:increment('article_count', 1)
        if socialize then
            new(BlogHasNewArticle):generate(user, topic, topic:blogs():first())
        end
    else
        user:increment('topic_count', 1)
    end

    topic:collectImages()
    
    return observer:creatorSucceed(topic)
end

function _M:update(observer, user, data, topic, subject)

    self:saveData(data)

    if topic:isArticle() and subject == 'publish' and topic.is_draft == 'yes' then
        data.is_draft = 'no'
        -- Topic Published
        app(Notifier):newTopicNotify(user, mentionParser, topic)
        -- User activity
        app(UserPublishedNewTopic):generate(user, topic)
        app(BlogHasNewArticle):generate(user, topic, topic:blogs():first())
        user:decrement('draft_count', 1)
        user:increment('article_count', 1)
    end

    local tags = data.tags
    if tags then
        topic:retag(tags)
    else
        topic:untag()
    end

    topic:update(data)
    topic:collectImages()

    return observer:creatorSucceed(topic)
end

function _M.__:saveData(data, user, isCreate)

    local currTime = lf.datetime()
    if isCreate then
        data.user_id = user.id
        data.created_at = data.created_at or currTime
        data.category_id = tonumber(data.category_id)
    end
    data.updated_at = data.updated_at or currTime

    local body, summary
    body = self.mentionParser:parse(data.body)
    local markdown = new(Markdown)
    data.body_original = body
    body = markdown:convertMarkdownToHtml(body)
    body, summary = markdown:parseTopicSummary(body)
    data.body = body
    data.summary = tostring(summary)

    data.excerpt = StaticTopic.makeExcerpt(body)
    data.source = get_platform()
    if lf.isEmpty(data.slug) then
        data.slug = slug_trans(data.title)
    end

end

function _M:isDuplicate(data, user)

    local last_topic = Topic.where('user_id', user.id):orderBy('id', 'desc'):first()

    return last_topic and lf.eq(last_topic.title, data.title)
end

function _M:removeByCategory(id)

    Topic.where('category_id', '=', id):delete()
end

return _M

