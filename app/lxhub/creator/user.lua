
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new(userModel)

    local this = {
        userModel = userModel
    }
    
    return oo(this, mt)
end

function _M:create(observer, data)

    data.password = Hash(data.password)
    data.avatar = 'http://avatar.com/some.png'
    local user = User.create(data)

    if not user then
        
        return observer:userValidationError(user:getErrors())
    end
    -- user:cacheAvatar()
    
    return observer:userCreated(user)
end

return _M

