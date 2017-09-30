
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()
local Markdown = lx.use('.app.lxhub.markdown.markdown')
local get_platform = Ah.get_platform
local UserRepliedTopic = lx.use('.app.activity.userRepliedTopic')

function _M:new()

    local this = {
        mentionParser = new '.app.lxhub.notification.mention'
    }
    
    return oo(this, mt)
end

function _M:create(observer, data)

    -- 检查是否重复发布评论
    if self:isDuplicateReply(data) then
        local errorMessages = new('msgBag')
        errorMessages:add('duplicated', '请不要发布重复内容。')
        
        return observer:creatorFailed(errorMessages)
    end
    data.user_id = Auth.id()
    data.body = self.mentionParser:parse(data.body)
    local markdown = new(Markdown)
    data.body_original = data.body
    data.body = markdown:convertMarkdownToHtml(data.body)
    data.source = get_platform()
    local reply = Reply.create(data)
    if not reply then
        
        return observer:creatorFailed(reply:getErrors())
    end
    -- Add the reply user
    local topic = Topic.find(data.topic_id)
    topic.last_reply_user_id = Auth.id()
    topic.reply_count = topic.reply_count + 1
    topic.updated_at = lf.datetime()
    topic:save()
    Auth.user():increment('reply_count', 1)
    app('.app.lxhub.notification.notifier'):newReplyNotify(Auth.user(), self.mentionParser, topic, reply)
    app(UserRepliedTopic):generate(Auth.user(), topic, reply)
    
    return observer:creatorSucceed(reply)
end

function _M:isDuplicateReply(data)

    local last_reply = Reply.where('user_id', Auth.id()):where('topic_id', data.topic_id):orderBy('id', 'desc'):first()
    
    return last_reply and lf.eq(last_reply.body_original, data.body)
end

return _M

