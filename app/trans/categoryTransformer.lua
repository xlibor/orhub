
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseTransformer'
}

local app, lf, tb, str = lx.kit()

function _M:transformData(model)

    return {id = model.id, name = model.name}
end

return _M

