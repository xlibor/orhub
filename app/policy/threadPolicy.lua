
local lx, _M = oo{
    _cls_ = '',
    _mix_ = 'handleAuthorization'
}

local app, lf, tb, str = lx.kit()

function _M:show(user, thread)

    return thread:hasParticipant(user.id)
end

return _M

