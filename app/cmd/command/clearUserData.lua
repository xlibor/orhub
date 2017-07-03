
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'lxhub:clear-user-data {user_id}',
        description = 'Clear user data
                            {user_id : User ID }
                            '
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    local user_id = self:argument('user_id')
    Topic.where('user_id', user_id):delete()
    Reply.where('user_id', user_id):delete()
    Notification.where('user_id', user_id):delete()
    Vote.where('user_id', user_id):delete()
    ActiveUser.where('user_id', user_id):delete()
end

return _M

