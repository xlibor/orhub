
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:getRememberToken()

    return self.remember_token
end

function _M:setRememberToken(value)

    self.remember_token = value
end

function _M:getRememberTokenName()

    return 'remember_token'
end

return _M

