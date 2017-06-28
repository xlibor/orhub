
local lx, _M, mt = oo{
    _cls_ = '',
    _mix_ = 'handlesAuthorization'
}

local app, lf, tb, str = lx.kit()
function _M:show(user, thread)

    return thread:hasParticipant(user.id)
end

return _M

