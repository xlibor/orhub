
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'messengerMessage'
}

local app, lf, tb, str = lx.kit()

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

return _M

