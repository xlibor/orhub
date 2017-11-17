
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
        email = 'required|email',
        password = 'required|confirmed|min:6'
    }
end

return _M

