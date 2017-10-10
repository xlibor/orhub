
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'baseFormRequest'
}

local app, lf, tb, str = lx.kit()

function _M:authorize()

    return true
end

function _M:rules()

    return {
        title = 'required|min:2',
        body = 'required|min:2',
        category_id = 'required|numeric'
    }
end

return _M

