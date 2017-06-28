
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.fillable = {'causer', 'indentifier', 'type', 'data'}

end

function _M:user()

    return self:belongsTo(User.class)
end

function _M:scopeRecent(query)

    return query:orderBy('id', 'desc')
end

function _M:getDataAttr(value)

    return lf.unpack(value)
end

return _M

