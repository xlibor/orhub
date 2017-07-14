
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        mentionParser = nil
    }
    
    return oo(this, mt)
end

function _M:ctor(mentionParser)

    self.mentionParser = mentionParser
end

function _M:create(observer, data, blog)

    -- 检查是否重复发布
    if self:isDuplicate(data) then
        
        return observer:creatorFailed('请不要发布重复内容。')
    end
    data['user_id'] = Auth.id()
    data['created_at'] = Carbon.now():toDateTimeString()
    data['updated_at'] = Carbon.now():toDateTimeString()
    -- @ user
    data['body'] = self.mentionParser:parse(data['body'])
    local markdown = new('markdown')
    data['body_original'] = data['body']
    data['body'] = markdown:convertMarkdownToHtml(data['body'])
    data['excerpt'] = Topic.makeExcerpt(data['body'])
    data['source'] = get_platform()
    data['slug'] = slug_trans(data['title'])
    local topic = Topic.create(data)
    if not topic then
        
        return observer:creatorFailed(topic:getErrors())
    end
    if blog then
        blog:topics():attach(topic.id)
        -- Co-authors
        if not blog:authors():where('user_id', topic.user_id):exists() then
            blog:authors():attach(topic.user_id)
        end
    end
    if topic.is_draft ~= 'yes' and topic.category_id ~=Conf('lxhub.adminBoardCid') then
        app('lxhub\\Notification\\Notifier'):newTopicNotify(Auth.user(), self.mentionParser, topic)
        app(UserPublishedNewTopic.class):generate(Auth.user(), topic)
    end
    if topic:isArticle() and topic.is_draft == 'yes' then
        Auth.user():increment('draft_count', 1)
    elseif topic:isArticle() then
        Auth.user():increment('article_count', 1)
        blog:increment('article_count', 1)
        app(BlogHasNewArticle.class):generate(Auth.user(), topic, topic:blogs():first())
    else 
        Auth.user():increment('topic_count', 1)
    end
    topic:collectImages()
    
    return observer:creatorSucceed(topic)
end

function _M:isDuplicate(data)

    local last_topic = Topic.where('user_id', Auth.id()):orderBy('id', 'desc'):first()
    
    return #last_topic and strcmp(last_topic.title, data['title']) == 0
end

return _M

