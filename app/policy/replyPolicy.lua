
local lx, _M = oo{
    _cls_ = '',
    _mix_ = 'handleAuthorization'
}

local app, lf, tb, str = lx.kit()

function _M:delete(user, reply)

    return user:may('manage_topics') or reply.user_id == user.id
end

return _M

