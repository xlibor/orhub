
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()
local use = lx.use
local Markdown = use('.app.lxhub.markdown.markdown')
local Notifier = use('.app.lxhub.notification.notifier')
local UserPublishedNewTopic = use('.app.activity.userPublishedNewTopic')
local BlogHasNewArticle = use('.app.activity.blogHasNewArticle')
local staticTopic = use('.app.model.topic')

local get_platform = Ah.get_platform
local slug_trans = Ah.slug_trans

function _M:new()

    local this = {
        mentionParser = new '.app.lxhub.notification.mention'
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
    data.excerpt = staticTopic.makeExcerpt(data.body)
    data.source = get_platform()
    data.slug = slug_trans(data.title)
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
    -- topic:collectImages()
    
    return observer:creatorSucceed(topic)
end

function _M:isDuplicate(data)

    local last_topic = Topic.where('user_id', Auth.id()):orderBy('id', 'desc'):first()
    
    return last_topic and lf.eq(last_topic.title, data.title)
end

return _M

