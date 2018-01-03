
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'model',
    _mix_       = 'presentableMix',
    _static_    = {}
}

local app, lf, tb, str = lx.kit()
local new = lx.new
local dispatch = function() end
local static

function _M._init_(this)

    static = this.static
end

function _M:ctor()

    self.presenter = '.app.core.presenter.notification'
    self.fillable = {
        'from_user_id', 'user_id', 'topic_id',
        'reply_id', 'body', 'type'
    }
end

-- Don't forget to fill this table

function _M:user()

    return self:belongsTo(User)
end

function _M:topic()

    return self:belongsTo(Topic)
end

function _M:fromUser()

    return self:belongsTo(User, 'from_user_id')
end

-- for api
function _M:from_user()

    return self:belongsTo(User, 'from_user_id')
end

function _M.s__.batchNotify(type, fromUser, users, topic, reply, content)

    local job
    local nowTimestamp = lf.datetime()
    local data = {}
    for _, toUser in ipairs(users) do
        if fromUser.id ~= toUser.id then
            tapd(data, {
                from_user_id = fromUser.id,
                user_id = toUser.id,
                topic_id = topic.id,
                reply_id = reply and reply.id or 0,
                body = content or (reply and reply.body or ''),
                type = type,
                created_at = nowTimestamp,
                updated_at = nowTimestamp
            })
            toUser:increment('notification_count', 1)
        end
    end
    if #data then
        Notification.inserts(data)
        for _, toUser in ipairs(users) do
            -- todo
            -- job = (new('sendNotifyMail', type, fromUser, toUser, topic, reply, content)):delay(config('orhub.notifyDelay'))
            -- dispatch(job)
        end
    end
    for _, value in pairs(data) do
        static.pushNotification(value)
    end
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

function _M.s__.notify(type, fromUser, toUser, topic, reply)

    if fromUser.id == toUser.id then
        
        return
    end
    if topic and static.isNotified(fromUser.id, toUser.id, topic.id, type) then
        
        return
    end
    local nowTimestamp = lf.datetime()
    local data = {
        from_user_id = fromUser.id,
        user_id = toUser.id,
        topic_id = topic and topic.id or 0,
        reply_id = reply and reply.id or 0,
        body = reply and reply.body or '',
        type = type,
        created_at = nowTimestamp,
        updated_at = nowTimestamp
    }
    toUser:increment('notification_count', 1)
    Notification.insert(data)
    -- local job = new('sendNotifyMail', type, fromUser, toUser, topic, reply):delay(config('orhub.notifyDelay'))
    -- dispatch(job)
    static.pushNotification(data)
end

function _M.s__.pushNotification(data)

    local notification = Notification.query():with('fromUser', 'topic'):where(data):first()
    if not notification then
        
        return
    end
    local from_user_name = notification('fromUser').name
    local topic_title = notification('topic') and notification('topic').title or '关注了你'
    local msg = from_user_name .. ' • ' .. notification:present():lableUp() .. ' • ' .. topic_title
    local push_data = tb.only(data, {'topic_id', 'from_user_id', 'type'})
    if data['reply_id'] ~= 0 then
        push_data['reply_id'] = data['reply_id']
        -- push_data['replies_url'] = route('replies.web_view', data['reply_id']);
    end
end

function _M.s__.isNotified(from_user_id, user_id, topic_id, type)

    local notifys = Notification.fromWhom(from_user_id):toWhom(user_id):atTopic(topic_id):withType(type):get()
    
    return notifys:count()
end

function _M:scopeFromWhom(query, from_user_id)

    return query:where('from_user_id', '=', from_user_id)
end

function _M:scopeToWhom(query, user_id)

    return query:where('user_id', '=', user_id)
end

function _M:scopeWithType(query, type)

    return query:where('type', '=', type)
end

function _M:scopeAtTopic(query, topic_id)

    return query:where('topic_id', '=', topic_id)
end

return _M

