
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    _bond_ = 'userCreatorListener',
    _mix_ = 'verifiesUsers, SocialiteHelper, AuthenticatesAndRegistersUsers, ThrottlesLogins'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        redirectTo = '/topics'
    }
    
    return oo(this, mt)
end

-- Create a new authentication controller instance.


function _M:ctor(userModel)

    self:middleware('guest', {except = {'logout', 'oauth', 'callback', 'getVerification', 'userBanned'}})
end

function _M.__:loginUser(user)

    if user.is_banned == 'yes' then
        
        return self:userIsBanned(user)
    end
    
    return self:userFound(user)
end

function _M:logout()

    Auth.logout()
    Flash.success(lang('Operation succeeded.'))
    
    return redirect(route('home'))
end

function _M:loginRequired()

    return view('auth.loginrequired')
end

function _M:signin()

    return view('auth.signin')
end

function _M:signinStore()

    return view('auth.signin')
end

function _M:adminRequired()

    return view('auth.adminrequired')
end

-- Shows a user what their new account will look like.

function _M:create()

    if not Session.has('oauthData') then
        
        return redirect():route('login')
    end
    local oauthData = tb.merge(Session.get('oauthData'), Session.get('_old_input', {}))
    
    return view('auth.signupconfirm', compact('oauthData'))
end

-- Actually creates the new user account

function _M:createNewUser(request)

    if not Session.has('oauthData') then
        
        return redirect():route('login')
    end
    local oauthUser = tb.merge(Session.get('oauthData'), request:only('name', 'email', 'password'))
    local userData = array_only(oauthUser, tb.keys(request:rules()))
    userData['register_source'] = oauthUser['driver']
    
    return app(\Phphub\Creators\UserCreator.class):create(self, userData)
end

function _M:userBanned()

    if Auth.check() and Auth.user().is_banned == 'no' then
        
        return redirect(route('home'))
    end
    
    return view('auth.userbanned')
end

------------------------------------------
-- UserCreatorListener Delegate
------------------------------------------

function _M:userValidationError(errors)

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

    if driver == 'github' then
        oauthData['image_url'] = registerUserData.user['avatar_url']
        oauthData['github_id'] = registerUserData.user['id']
        oauthData['github_url'] = registerUserData.user['url']
        oauthData['github_name'] = registerUserData.nickname
        oauthData['name'] = registerUserData.user['name']
        oauthData['email'] = registerUserData.user['email']
    elseif driver == 'wechat' then
        oauthData['image_url'] = registerUserData.avatar
        oauthData['wechat_openid'] = registerUserData.id
        oauthData['name'] = registerUserData.nickname
        oauthData['email'] = registerUserData.email
        oauthData['wechat_unionid'] = registerUserData.user['unionid']
    end
    oauthData['driver'] = driver
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
function _M:userIsBanned(user)

    return redirect(route('user-banned'))
end

------------------------------------------
-- Email Validation
------------------------------------------

function _M:getVerification(request, token)

    self:validateRequest(request)
    try(function()
        UserVerification.process(request:input('email'), token, 'users')
        Flash.success(lang('Email validation successed.'))
        
        return redirect('/')
    end)
    :catch(function(UserNotFoundException e) 
        Flash.error(lang('Email not found'))
        
        return redirect('/')
    end)
    :catch(function(UserIsVerifiedException e) 
        Flash.success(lang('Email validation successed.'))
        
        return redirect('/')
    end)
    :catch(function(TokenMismatchException e) 
        Flash.error(lang('Token mismatch'))
        
        return redirect('/')
    end)
    :run()
    
    return redirect('/')
end

return _M

