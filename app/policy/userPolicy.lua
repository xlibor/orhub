
local lx, _M = oo{
    _cls_ = '',
    _mix_ = 'handleAuthorization'
}

local app, lf, tb, str = lx.kit()

function _M:update(currentUser, user)

    return currentUser:may('manage_users') or currentUser.id == user.id
end

function _M:delete(currentUser, user)

    return currentUser:may('manage_users') or currentUser.id == user.id
end

return _M

