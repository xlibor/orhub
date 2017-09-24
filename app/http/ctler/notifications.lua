
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()
local redirect = lx.h.redirect

function _M:ctor()

    self:setBar('auth')
end

function _M:unread(c)

    if Auth.user().notification_count > 0 and Auth.user().message_count == 0 then
        
        return redirect():route('notifications.index')
    end
    
    return redirect():route('messages.index')
end

function _M:index(c)

    local notifications = Auth.user():notifications()
    Auth.user().notification_count = 0
    Auth.user():save()
    
    return c:view('notifications.index', Compact('notifications'))
end

function _M:count()

    return Auth.user().notification_count + Auth.user().message_count
end

return _M

