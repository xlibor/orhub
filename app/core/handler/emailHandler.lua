
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        methodMap = {
        at = 'sendAtNotifyMail',
        mentioned_in_topic = 'sendMentionedInTopicNotifyMail',
        attention = 'sendAttentionNotifyMail',
        vote_append = 'sendVoteAppendNotifyMail',
        comment_append = 'sendCommentAppendNotifyMail',
        attented_append = 'sendAttendAppendNotifyMail',
        new_reply = 'sendNewReplyNotifyMail',
        new_message = 'sendNewMessageNotifyMail'
    },
        type = nil,
        fromUser = nil,
        toUser = nil,
        topic = nil,
        reply = nil,
        body = nil
    }
    
    return oo(this, mt)
end

function _M:sendMaintainerWorksMail(user, timeFrame, content)

    Mail.send('emails.fake', {}, function(message)
        message:subject('管理员工作统计')
        message:getSwiftMessage():setBody(new('sendCloudTemplate', 'maintainer_works', {name = user.name, time_frame = timeFrame, content = content}))
        message:to(user.email)
    end)
end

function _M:sendActivateMail(user)

    UserVerification.generate(user)
    local token = user.verification_token
    Mail.send('emails.fake', {}, function(message)
        message:subject(lang('Please verify your email address'))
        message:getSwiftMessage():setBody(new('sendCloudTemplate', 'template_active', {name = user.name, url = url('verification', user.verification_token) .. '?email=' .. urlencode(user.email)}))
        message:to(user.email)
    end)
end

function _M:sendNotifyMail(type, fromUser, toUser, topic, reply, body)

    if not self.methodMap[type] or toUser.email_notify_enabled ~= 'yes' or toUser.id == fromUser.id or not toUser.email or toUser.verified ~= 1 or self:_checkNecessary(type, toUser) then
        
        return false
    end
    self.topic = topic
    self.reply = reply
    self.body = body
    self.fromUser = fromUser
    self.toUser = toUser
    self.type = type
    local method = self.methodMap[type]
    self:[method]()
end

function _M.__:sendNewMessageNotifyMail()

    if not self.body then
        
        return false
    end
    local action = " 发了一条私信给你。内容如下：<br />"
    self:_send(nil, self.fromUser, '你有新的私信', action, self.body, self.body)
end

function _M.__:sendNewReplyNotifyMail()

    if not self.reply then
        
        return false
    end
    local action = " 回复了你的主题: <a href='" .. self.reply.topic:link() .. "' target='_blank'>{self.reply.topic.title}</a><br /><br />内容如下：<br />"
    self:_send(self.topic, self.fromUser, '你的主题有新评论', action, self.reply.body, self.reply.body)
end

function _M.__:sendAtNotifyMail()

    if not self.reply then
        
        return false
    end
    local action = " 在主题: <a href='" .. self.topic:link({'#reply' .. self.reply.id}) .. "' target='_blank'>{self.reply.topic.title}</a> 的评论中提及了你<br /><br />内容如下：<br />"
    self:_send(self.topic, self.fromUser, '有用户在评论中提及你', action, self.reply.body, self.reply.body)
end

function _M.__:sendAttentionNotifyMail()

    if not self.reply then
        
        return false
    end
    local action = " 评论了你关注的主题: <a href='" .. self.topic:link({'#reply' .. self.reply.id}) .. "' target='_blank'>{self.reply.topic.title}</a><br /><br />评论内容如下：<br />"
    self:_send(self.topic, self.fromUser, '有用户评论了你关注的主题', action, self.reply.body, self.reply.body)
end

function _M.__:sendVoteAppendNotifyMail()

    if not self.body or not self.topic then
        
        return false
    end
    local action = " 你点过赞的话题: <a href='" .. self.topic:link() .. "' target='_blank'>{self.topic.title}</a> 有新附言<br /><br />附言内容如下：<br />"
    self:_send(self.topic, '', '你点过赞的话题有新附言', action, self.body, self.body)
end

function _M.__:sendCommentAppendNotifyMail()

    if not self.body or not self.topic then
        
        return false
    end
    local action = " 你评论过的话题: <a href='" .. self.topic:link() .. "' target='_blank'>{self.topic.title}</a> 有新附言<br /><br />附言内容如下：<br />"
    self:_send(self.topic, '', '你评论过的话题有新附言', action, self.body, self.body)
end

function _M.__:sendAttendAppendNotifyMail()

    if not self.body or not self.topic then
        
        return false
    end
    local action = " 你关注的话题: <a href='" .. self.topic:link() .. "' target='_blank'>{self.topic.title}</a> 有新附言<br /><br />附言内容如下：<br />"
    self:_send(self.topic, '', '你关注的话题有新附言', action, self.body, self.body)
end

function _M.__:sendMentionedInTopicNotifyMail()

    if not self.topic then
        
        return false
    end
    local action = " 在主题: <a href='" .. self.topic:link() .. "' target='_blank'>{self.topic.title}</a> 中提及了你。<br />"
    self:_send(self.topic, self.fromUser, '有用户在主题中提及你', action, '', '')
end

function _M.__:generateMailLog(body)

    body = body or ''
    local data = {}
    data['from_user_id'] = self.fromUser.id
    data['user_id'] = self.toUser.id
    data['type'] = self.type
    data['body'] = body
    data['reply_id'] = self.reply and self.reply.id or 0
    data['topic_id'] = self.topic and self.topic.id or 0
    NotificationMailLog.create(data)
end

function _M.__:_correctSubject(subject, topic)

    if topic:isArticle() then
        subject = str.replace(subject, '主题', '文章')
        
        return str.replace(subject, '话题', '文章')
    end
    
    return subject
end

function _M.__:_correctAction(action, topic)

    if topic:isArticle() then
        action = str.replace(action, '话题', '文章')
        action = str.replace(action, '主题', '文章')
        action = str.replace(action, 'topics', 'articles')
    end
    
    return action
end

function _M.__:_send(topic, user, subject, action, content, mailog)

    mailog = mailog or ''
    local name = user and "<a href='" .. url(route('users.show', user.id)) .. "' target='_blank'>{user.name}</a>" or ''
    if topic then
        subject = self:_correctAction(subject, topic)
        action = self:_correctAction(action, topic)
    end
    Mail.send('emails.fake', {}, function(message)
        message:subject(subject)
        message:getSwiftMessage():setBody(new('sendCloudTemplate', 'notification_mail', {name = name, action = action, content = content}))
        message:to(self.toUser.email)
        self:generateMailLog(mailog)
    end)
end

function _M.__:_checkNecessary(type, toUser)

    -- 从数据库中重新读取用户
    local user = User.find(toUser.id)
    -- 私信，如果已读
    if type == 'new_message' and user.message_count <= 0 then
        
        return true
        -- 通知，如果已读
    elseif user.notification_count <= 0 then
        
        return true
    end
    
    return false
end

return _M

