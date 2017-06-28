
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'messengerParticipant'
}

local app, lf, tb, str = lx.kit()

function _M:scopeByWhom(query, user_id)

    return query:where('user_id', '=', user_id)
end

return _M

