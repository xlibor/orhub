
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

local driverMap = {
    github = 'getByGithubId',
    wechat = 'getByWechatId',
    qq = 'getByQqId'
}

function _M:getByDriver(driver, id)

    local func = driverMap[driver]

    if not func then
        error('invalid driver:' .. tostring(driver))
    end
    
    return lf.call({self, func}, id)
end

function _M:getByGithubId(id)

    return User.where('github_id', '=', id):first()
end

function _M:getByWechatId(id)

    return User.where('wechat_openid', '=', id):first()
end

function _M:getByQqId(id)

    return User.where('qq_openid', '=', id):first()
end

return _M

