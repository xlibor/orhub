
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        fillable = {'causer', 'indentifier', 'type', 'data'}
    }
    
    return oo(this, mt)
end

function _M:user()

    return self:belongsTo(User.class)
end

function _M:scopeRecent(query)

    return query:orderBy('id', 'desc')
end

function _M:getDataAttribute(value)

    return unserialize(value)
end

return _M

