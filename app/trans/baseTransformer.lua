
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'transformerAbstract'
}

local app, lf, tb, str = lx.kit()

function _M:transform(model)

    local data = self:transformData(model)
    -- 转换 null 字段为空字符串
    for _, key in pairs(tb.keys(data)) do
        if not data[key] then
            data[key] = ''
            continue
        end
        if not data[key] then
            data[key] = ''
        end
    end
    
    return data
end

function _M:transformData(model) end

return _M

