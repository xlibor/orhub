
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:getByDriver(driver, id)

    local functionMap = {github = 'getByGithubId', wechat = 'getByWechatId'}
    local func = functionMap[driver]
    if not func then
        
        return nil
    end
    
    return lf.call({self, func}, id)
end

function _M:getByGithubId(id)

    return User.where('github_id', '=', id):first()
end

function _M:getByWechatId(id)

    return User.where('wechat_openid', '=', id):first()
end

return _M

