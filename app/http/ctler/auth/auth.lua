
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    -- _bond_ = 'userCreatorListener',
    _mix_ = {
        -- 'verifiesUsers',
        'socialiteHelper',
        'auth.authenticateUser',
        'auth.regUser'
    }
}

local app, lf, tb, str, new = lx.kit()
local try = lx.try
local redirect, route = lx.h.redirect, lx.h.route
local lang = Ah.lang

function _M:ctor()
    
    self.redirectTo = '/topics'
    self:setBar('guest', {except = {'logout', 'oauth', 'callback', 'getVerification', 'userBanned'}})
end

function _M.__:loginUser(user)

    if user.is_banned == 'yes' then
        
        return self:userIsBanned(user)
    end
    
    return self:userFound(user)
end

function _M:logout(c)

    Auth.logout()
    Flash.success(lang('Operation succeeded.'))
    
    return redirect(route('home'))
end

function _M:loginRequired(c)

    c:view('auth.loginrequired')
end

function _M:signin(c)

    c:view('auth.signin')
end

function _M:signinStore(c)

    c:view('auth.signin')
end

function _M:adminRequired(c)

    c:view('auth.adminrequired')
end

-- Shows a user what their new account will look like.

function _M:create(c)

    if not Session.has('oauthData') then
        
        return redirect():route('login')
    end
    local oauthData = tb.merge(Session.get('oauthData'), Session.get('_old_input', {}))
    
    c:view('auth.signupconfirm', Compact('oauthData'))
end

-- Actually creates the new user account

function _M:createNewUser(c)

    local request = c:form('storeUserRequest')

    if not Session.has('oauthData') then
        
        return redirect():route('login')
    end
    local oauthUser = tb.merge(Session.get('oauthData'), request:only('name', 'email', 'password'))
    local userData = tb.only(oauthUser, tb.keys(request:rules()))
    userData.register_source = oauthUser['driver']
    
    return new('.app.lxhub.creator.user'):create(self, userData)
end

function _M:userBanned(c)

    if Auth.check() and Auth.user().is_banned == 'no' then
        
        return redirect(route('home'))
    end
    
    c:view('auth.userbanned')
end

------------------------------------------
-- UserCreatorListener Delegate
------------------------------------------

function _M:userValidationError(c, errors)

    return redirect('/')
end

function _M:userCreated(user)

    Auth.login(user, true)
    Session.forget('oauthData')
    Flash.success(lang('Congratulations and Welcome!'))
    
    return redirect(route('users.edit', Auth.user().id))
end

------------------------------------------
-- GithubAuthenticatorListener Delegate
------------------------------------------

function _M:userNotFound(driver, registerUserData)

    local oauthData = {}
    if driver == 'github' then
        oauthData.image_url = registerUserData.user.avatar_url
        oauthData.github_id = registerUserData.user.id
        oauthData.github_url = registerUserData.user.url
        oauthData.github_name = registerUserData.nickname
        oauthData.name = registerUserData.user.name
        oauthData.email = registerUserData.user.email
    elseif driver == 'wechat' then
        oauthData.image_url = registerUserData.avatar
        oauthData.wechat_openid = registerUserData.id
        oauthData.name = registerUserData.nickname
        oauthData.email = registerUserData.email
        oauthData.wechat_unionid = registerUserData.user.unionid
    end
    oauthData.driver = driver

    Session.put('oauthData', oauthData)
    
    return redirect(route('signup'))
end

-- 数据库有用户信息, 登录用户
function _M:userFound(user)

    Auth.login(user, true)
    Session.forget('oauthData')
    Flash.success(lang('Login Successfully.'))
    
    return redirect(route('users.edit', Auth.user().id))
end

-- 用户屏蔽
function _M:userIsBanned(c, user)

    return redirect(route('user-banned'))
end

------------------------------------------
-- Email Validation
------------------------------------------

function _M:getVerification(c, token)

    local request = c.req
    self:validateRequest(request)
    try(function()
        UserVerification.process(request:input('email'), token, 'users')
        Flash.success(lang('Email validation successed.'))
        
        return redirect('/')
    end)
    :catch('userNotFoundException', function(e) 
        Flash.error(lang('Email not found'))
        
        return redirect('/')
    end)
    :catch('userIsVerifiedException', function(e) 
        Flash.success(lang('Email validation successed.'))
        
        return redirect('/')
    end)
    :catch('tokenMismatchException', function(e) 
        Flash.error(lang('Token mismatch'))
        
        return redirect('/')
    end)
    :run()
    
    return redirect('/')
end

return _M

