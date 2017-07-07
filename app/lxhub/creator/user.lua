-- This class can call the following methods on the observer object:
-- userValidationError($errors)
-- userCreated($user)


local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        userModel = nil
    }
    
    return oo(this, mt)
end

function _M:ctor(userModel)

    self.userModel = userModel
end

function _M:create(observer, data)

    data['password'] = bcrypt(data['password'])
    local user = User.create(data)
    if not user then
        
        return observer:userValidationError(user:getErrors())
    end
    user:cacheAvatar()
    
    return observer:userCreated(user)
end

return _M

