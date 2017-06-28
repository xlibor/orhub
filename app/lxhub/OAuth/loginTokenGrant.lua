
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseGrant'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        identifier = 'login_token'
    }
    
    return oo(this, mt)
end

function _M:getUserId(request, verifier)

    -- get('username') 为客户端的兼容写法
    -- 修改为 user id 会更加稳定
    local user_id = self.server:getRequest().request:get('username', nil)
    if not user_id then
        lx.throw(InvalidRequestException, 'user_id')
    end
    local login_token = self.server:getRequest().request:get('login_token', nil)
    if not login_token then
        lx.throw(InvalidRequestException, 'login_token')
    end
    
    return lf.call(verifier, user_id, login_token)
end

return _M

