
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'request'
}

local app, lf, tb, str = lx.kit()

function _M:authorize()

    return true
end

function _M:rules()

    return {
        github_id = 'unique:users',
        github_name = 'string',
        wechat_openid = 'string',
        name = 'alpha_num|required|unique:users',
        email = 'email|required|unique:users',
        github_url = 'url',
        image_url = 'url',
        wechat_unionid = 'string',
        password = 'required|confirmed|min:6'
    }
end

return _M

