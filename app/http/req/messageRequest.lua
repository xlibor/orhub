
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'request'
}

local app, lf, tb, str = lx.kit()

function _M:authorize()

    return true
end

function _M:rules()

    return {message = 'required|min:1'}
end

return _M

