
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:verify(user_id, login_token)

    local user = User.query():where({id = user_id}):first({'id', 'login_token'})
    if #user and user.login_token == login_token then
        
        return user.id
    end
    
    return false
end

return _M

