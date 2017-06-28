
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:index()

    local notifications = Auth.user():notifications()
    Auth.user().notification_count = 0
    Auth.user():save()
    
    return self:response():paginator(notifications, new('notificationTransformer'))
end

function _M:unreadMessagesCount()

    local count = Auth.user().notification_count
    
    return response(compact('count'))
end

return _M

