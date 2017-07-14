
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self:middleware('auth', {except = {'index', 'show', 'replies', 'topics', 'articles', 'votes', 'following', 'followers', 'githubCard', 'githubApiProxy'}})
end

function _M:index()

    local users = User.recent():take(48):get()
    
    return view('users.index', Compact('users'))
end

function _M:show(id)

    local user = User.findOrFail(id)
    local topics = Topic.whose(user.id):withoutArticle():withoutBoardTopics():recent():limit(20):get()
    local articles = Topic.whose(user.id):onlyArticle():withoutDraft():recent():with('blogs'):limit(20):get()
    local blog = user:blogs():first()
    local replies = Reply.whose(user.id):recent():limit(20):get()
    
    return view('users.show', Compact('user', 'blog', 'articles', 'topics', 'replies'))
end

function _M:edit(id)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    
    return view('users.edit', Compact('user', 'topics', 'replies'))
end

function _M:update(id, request)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    try(function()
        request:performUpdate(user)
        Flash.success(lang('Operation succeeded.'))
    end)
    :catch(function(ImageUploadException exception) 
        Flash.error(lang(exception:getMessage()))
    end)
    :run()
    
    return redirect(route('users.edit', id))
end

function _M:replies(id)

    local user = User.findOrFail(id)
    local replies = Reply.whose(user.id):recent():paginate(15)
    
    return view('users.replies', Compact('user', 'replies'))
end

function _M:topics(id)

    local user = User.findOrFail(id)
    local topics = Topic.whose(user.id):withoutArticle():withoutBoardTopics():recent():paginate(30)
    
    return view('users.topics', Compact('user', 'topics'))
end

function _M:articles(id)

    local user = User.findOrFail(id)
    local topics = Topic.whose(user.id):onlyArticle():withoutDraft():recent():with('blogs'):paginate(30)
    user:update({article_count = topics:total()})
    
    return view('users.articles', Compact('user', 'blog', 'topics'))
end

function _M:drafts()

    local user = Auth.user()
    local topics = user:topics():onlyArticle():draft():recent():paginate(30)
    local blog = user:blogs():first()
    user.draft_count = user:topics():onlyArticle():draft():count()
    user:save()
    
    return view('users.articles', Compact('user', 'blog', 'topics'))
end

function _M:votes(id)

    local user = User.findOrFail(id)
    local topics = user:votedTopics():orderBy('pivot_created_at', 'desc'):paginate(30)
    
    return view('users.votes', Compact('user', 'topics'))
end

function _M:following(id)

    local user = User.findOrFail(id)
    local users = user:followings():orderBy('id', 'desc'):paginate(15)
    
    return view('users.following', Compact('user', 'users'))
end

function _M:followers(id)

    local user = User.findOrFail(id)
    local users = user:followers():orderBy('id', 'desc'):paginate(15)
    
    return view('users.followers', Compact('user', 'users'))
end

function _M:accessTokens(id)

    if not Auth.check() or Auth.id() ~= id then
        
        return redirect(route('users.show', id))
    end
    local user = User.findOrFail(id)
    local sessions = OAuthSession.where({owner_type = 'user', owner_id = Auth.id()}):with('token'):lists('id') or {}
    local tokens = AccessToken.whereIn('session_id', sessions):get()
    
    return view('users.access_tokens', Compact('user', 'tokens'))
end

function _M:revokeAccessToken(token)

    local access_token = AccessToken.with('session'):find(token)
    if not access_token or not Auth.check() or access_token.session.owner_id ~= Auth.id() then
        Flash.error(lang('Revoke Failed'))
    else 
        access_token:delete()
        Flash.success(lang('Revoke success'))
    end
    
    return redirect(route('users.access_tokens', Auth.id()))
end

function _M:blocking(id)

    local user = User.findOrFail(id)
    user.is_banned = user.is_banned == 'yes' and 'no' or 'yes'
    user:save()
    -- 用户被屏蔽后屏蔽用户所有内容，解封时解封所有内容
    user:topics():update({is_blocked = user.is_banned})
    user:replies():update({is_blocked = user.is_banned})
    
    return redirect(route('users.show', id))
end

function _M:editEmailNotify(id)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    
    return view('users.edit_email_notify', Compact('user'))
end

function _M:updateEmailNotify(id, request)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    user.email_notify_enabled = request.email_notify_enabled == 'on' and 'yes' or 'no'
    user:save()
    Flash.success(lang('Operation succeeded.'))
    
    return redirect(route('users.edit_email_notify', id))
end

function _M:editPassword(id)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    
    return view('users.edit_password', Compact('user'))
end

function _M:updatePassword(id, request)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    user.password = bcrypt(request.password)
    user:save()
    Flash.success(lang('Operation succeeded.'))
    
    return redirect(route('users.edit_password', id))
end

function _M:githubApiProxy(username)

    local cache_name = 'github_api_proxy_user_' .. username
    
    return Cache.remember(cache_name, 1440, function()
        result = (new('githubUserDataReader')):getDataFromUserName(username)
        
        return response():json(result)
    end)
end

function _M:regenerateLoginToken()

    if Auth.check() then
        Auth.user().login_token = str.random(rand(20, 32))
        Auth.user():save()
        Flash.success(lang('Regenerate succeeded.'))
    else 
        Flash.error(lang('Regenerate failed.'))
    end
    
    return redirect(route('users.show', Auth.id()))
end

function _M:doFollow(id)

    local user = User.findOrFail(id)
    if Auth.user():isFollowing(id) then
        Auth.user():unfollow(id)
        app(UserFollowedUser.class):remove(Auth.user(), user)
    else 
        Auth.user():follow(id)
        app('lxhub\\Notification\\Notifier'):newFollowNotify(Auth.user(), user)
        app(UserFollowedUser.class):generate(Auth.user(), user)
    end
    user:update({follower_count = user:followers():count()})
    Flash.success(lang('Operation succeeded.'))
    
    return redirect():back()
end

function _M:editAvatar(id)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    
    return view('users.edit_avatar', Compact('user'))
end

function _M:updateAvatar(id, request)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    local file = request:file('avatar')
    if file then
        try(function()
            user:updateAvatar(file)
            Flash.success(lang('Update Avatar Success'))
        end)
        :catch(function(ImageUploadException exception) 
            Flash.error(lang(exception:getMessage()))
        end)
        :run()
    else 
        Flash.error(lang('Update Avatar Failed'))
    end
    
    return redirect(route('users.edit_avatar', id))
end

function _M:sendVerificationMail()

    local user = Auth.user()
    local cache_key = 'send_activite_mail_' .. user.id
    if Cache.has(cache_key) then
        Flash.error(lang('The mail send failed! Please try again in 60 seconds.', {seconds = Cache.get(cache_key) - time()}))
    else 
        if not user.email then
            Flash.error(lang('The mail send failed! Please fill in your email address first.'))
        else 
            if not user.verified then
                dispatch(new('sendActivateMail', user))
                Flash.success(lang('The mail sent successfully.'))
                Cache.put(cache_key, time() + 60, 1)
            end
        end
    end
    
    return redirect():intended('/')
end

function _M:editSocialBinding(id)

    local user = User.findOrFail(id)
    self:authorize('update', user)
    
    return view('users.edit_social_binding', Compact('user'))
end

function _M:emailVerificationRequired()

    if \Auth.user().verified then
        
        return redirect():intended('/')
    end
    
    return view('users.emailverificationrequired')
end

return _M
