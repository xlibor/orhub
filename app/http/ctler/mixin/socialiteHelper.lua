
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

_M.__oauthDrivers = {github = 'github', wechat = 'weixin'}

function _M:oauth(request)

    local driver = request:input('driver')
    driver = not self.oauthDrivers[driver] and 'github' or self.oauthDrivers[driver]
    if Auth.check() and Auth.user().register_source == driver then
        
        return redirect('/')
    end
    
    return Socialite.driver(driver):redirect()
end

function _M:callback(request)

    local driver = request:input('driver')
    if not self.oauthDrivers[driver] or Auth.check() and Auth.user().register_source == driver then
        
        return redirect():intended('/')
    end
    local oauthUser = Socialite.with(self.oauthDrivers[driver]):user()
    local user = User.getByDriver(driver, oauthUser.id)
    if Auth.check() then
        if user and user.id ~= Auth.id() then
            Flash.error(lang('Sorry, this socialite account has been registed.', {driver = lang(driver)}))
        else 
            self:bindSocialiteUser(oauthUser, driver)
            Flash.success(lang('Bind Successfully!', {driver = lang(driver)}))
        end
        
        return redirect(route('users.edit_social_binding', Auth.id()))
    else 
        if user then
            
            return self:loginUser(user)
        end
        
        return self:userNotFound(driver, oauthUser)
    end
end

function _M:bindSocialiteUser(oauthUser, driver)

    local currentUser = Auth.user()
    if driver == 'github' then
        currentUser.github_id = oauthUser.id
        currentUser.github_url = oauthUser.user['url']
    elseif driver == 'wechat' then
        currentUser.wechat_openid = oauthUser.id
        currentUser.wechat_unionid = oauthUser.user['unionid']
    end
    currentUser:save()
end

return _M

