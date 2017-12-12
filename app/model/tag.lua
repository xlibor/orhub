
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'tagging.tag'
}

local app, lf, tb, str = lx.kit()

function _M:scopeHotTags(query, limit)

    return query:orderBy('count'):take(limit)
end

return _M

