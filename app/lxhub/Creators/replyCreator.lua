
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

function _M:create(observer, data)

    local errorMessages
    -- 检查是否重复发布评论
    if self:isDuplicateReply(data) then
        errorMessages = new('messageBag')
        errorMessages:add('duplicated', '请不要发布重复内容。')
        
        return observer:creatorFailed(errorMessages)
    end
    data['user_id'] = Auth.id()
    data['body'] = self.mentionParser:parse(data['body'])
    local markdown = new('markdown')
    data['body_original'] = data['body']
    data['body'] = markdown:convertMarkdownToHtml(data['body'])
    data['source'] = get_platform()
    local reply = Reply.create(data)
    if not reply then
        
        return observer:creatorFailed(reply:getErrors())
    end
    -- Add the reply user
    local topic = Topic.find(data['topic_id'])
    topic.last_reply_user_id = Auth.id()
    topic.reply_count = topic.reply_count + 1
    topic.updated_at = Carbon.now():toDateTimeString()
    topic:save()
    Auth().user:increment('reply_count', 1)
    app('lxhub\\Notification\\Notifier'):newReplyNotify(Auth().user, self.mentionParser, topic, reply)
    app(UserRepliedTopic.class):generate(Auth().user, topic, reply)
    
    return observer:creatorSucceed(reply)
end

function _M:isDuplicateReply(data)

    local last_reply = Reply.where('user_id', Auth.id()):where('topic_id', data['topic_id']):orderBy('id', 'desc'):first()
    
    return #last_reply and strcmp(last_reply.body_original, data['body']) == 0
end

return _M

