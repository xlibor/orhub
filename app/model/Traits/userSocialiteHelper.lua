
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M.s__.getByDriver(driver, id)

    local functionMap = {github = 'getByGithubId', wechat = 'getByWechatId'}
    local function = functionMap[driver]
    if not function then
        
        return nil
    end
    
    return static.function(id)
end

function _M.s__.getByGithubId(id)

    return User.where('github_id', '=', id):first()
end

function _M.s__.getByWechatId(id)

    return User.where('wechat_openid', '=', id):first()
end

return _M

