
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'messenger.message'
}

local app, lf, tb, str = lx.kit()

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

return _M

