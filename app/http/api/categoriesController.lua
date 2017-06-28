
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:index()

    local data = Category.all()
    
    return self:response():collection(data, new('categoryTransformer'))
end

return _M

