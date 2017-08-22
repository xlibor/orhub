
return function(route)

    ------------------ Page Route------------------------
    route:get('/', 'pages@home'):name('home')
    route:get('/about', 'pages@about'):name('about')
    route:get('/search', 'pages@search'):name('search')
    route:get('/feed', 'pages@feed'):name('feed')
    route:get('/wiki', 'pages@wiki'):name('wiki')
    route:get('/sitemap', 'pages@sitemap')
    route:get('/sitemap.xml', 'pages@sitemap')
    route:get('/hall_of_fames', 'pages@hallOfFames'):name('hall_of_fames')
    route:get('/composer', 'pages@composer'):name('composer')
    route:get('/roles/{id}', 'roles@show'):name('roles.show')
    ------------------ User stuff------------------------
    route:get('/users/drafts', 'users@drafts'):name('users.drafts')
    route:get('/users/{id}/replies', 'users@replies'):name('users.replies')
    route:get('/users/{id}/topics', 'users@topics'):name('users.topics')
    route:get('/users/{id}/articles', 'users@articles'):name('users.articles')
    route:get('/users/{id}/votes', 'users@votes'):name('users.votes')
    route:get('/users/{id}/following', 'users@following'):name('users.following')
    route:get('/users/{id}/followers', 'users@followers'):name('users.followers')
    route:get('/users/{id}/refresh_cache', 'users@refreshCache'):name('users.refresh_cache')
    route:get('/users/{id}/access_tokens', 'users@accessTokens'):name('users.access_tokens')
    route:get('/access_token/{token}/revoke', 'users@revokeAccessToken'):name('users.access_tokens.revoke')
    route:post('/users/regenerate_login_token', 'users@regenerateLoginToken'):name('users.regenerate_login_token')
    route:post('/users/follow/{id}', 'users@doFollow'):name('users.doFollow')
    route:get('/users/{id}/edit_email_notify', 'users@editEmailNotify'):name('users.edit_email_notify')
    route:post('/users/{id}/update_email_notify', 'users@updateEmailNotify'):name('users.update_email_notify')
    route:get('/users/{id}/edit_password', 'users@editPassword'):name('users.edit_password')
    route:patch('/users/{id}/update_password', 'users@updatePassword'):name('users.update_password')
    route:get('/users/{id}/edit_social_binding', 'users@editSocialBinding'):name('users.edit_social_binding')
    route:get('/users', 'users@index'):name('users.index')
    route:get('/users/create', 'users@create'):name('users.create')
    route:post('/users', 'users@store'):name('users.store')
    route:get('/users/{id}', 'users@show'):name('users.show')
    route:get('/users/{id}/edit', 'users@edit'):name('users.edit')
    route:patch('/users/{id}', 'users@update'):name('users.update')
    route:get('/users/{id}/edit_avatar', 'users@editAvatar'):name('users.edit_avatar')
    route:patch('/users/{id}/update_avatar', 'users@updateAvatar'):name('users.update_avatar')
    route:get('/notifications/unread', 'notifications@unread'):name('notifications.unread')
    route:get('/notifications', 'notifications@index'):name('notifications.index')
    route:get('/notifications/count', 'notifications@count'):name('notifications.count')
    route:get('/messages', 'messages@index'):name('messages.index')
    route:get('/messages/to/{id}', 'messages@create'):name('messages.create')
    route:post('/messages', 'messages@store'):name('messages.store')
    route:get('/messages/{id}', 'messages@show'):name('messages.show')
    route:put('/messages/{id}', 'messages@update'):name('messages.update')
    route:get('/email-verification-required', 'users@emailVerificationRequired'):name('email-verification-required')
    route:post('/users/send-verification-mail', 'users@sendVerificationMail'):name('users.send-verification-mail')
    ------------------ Authentication------------------------
    route:get('/login', 'auth.auth@oauth'):name('login')
    route:get('/auth/login', 'auth.auth@signin'):name('auth.login')
    route:post('/auth/login', 'auth.auth@login'):name('auth.login')
    route:get('/login-required', 'auth.auth@loginRequired'):name('login-required')
    route:get('/admin-required', 'auth.auth@adminRequired'):name('admin-required')
    route:get('/user-banned', 'auth.auth@userBanned'):name('user-banned')
    route:get('/signup', 'auth.auth@create'):name('signup')
    route:post('/signup', 'auth.auth@createNewUser'):name('signup')
    route:get('/logout', 'auth.auth@logout'):name('logout')
    route:get('/oauth', 'auth.auth@getOauth')
    route:get('/auth/oauth', 'auth.auth@oauth'):name('auth.oauth')
    route:get('/auth/callback', 'auth.auth@callback'):name('auth.callback')
    route:get('/verification/{token}', 'auth.auth@getVerification'):name('verification')
    ------------------ Categories------------------------
    route:get('categories/{id}', 'categories@show'):name('categories.show')
    ------------------ Site------------------------
    route:get('/sites', 'sites@index'):name('sites.index')
    ------------------ Replies------------------------
    route:post('/replies', 'replies@store'):name('replies.store'):bar('verified_email')
    route:delete('replies/delete/{id}', 'replies@destroy'):name('replies.destroy'):bar('auth')
    ------------------ Topic------------------------
    route:get('/topics', 'topics@index'):name('topics.index')
    route:get('/topics/create', 'topics@create'):name('topics.create'):bar('verified_email')
    route:post('/topics', 'topics@store'):name('topics.store'):bar('verified_email')
    route:get('/topics/{id}/edit', 'topics@edit'):name('topics.edit')
    route:patch('/topics/{id}', 'topics@update'):name('topics.update')
    route:delete('/topics/{id}', 'topics@destroy'):name('topics.destroy')
    route:post('/topics/{id}/append', 'topics@append'):name('topics.append')
    ------------------ User Topic Actions------------------------
    route:group({before = 'auth'}, function()
        route:post('/topics/{id}/upvote', 'topics@upvote'):name('topics.upvote')
        route:post('/topics/{id}/downvote', 'topics@downvote'):name('topics.downvote')
        route:post('/replies/{id}/vote', 'replies@vote'):name('replies.vote')
        route:post('/attentions/{id}', 'attentions@createOrDelete'):name('attentions.createOrDelete')
    end)
    ------------------ Admin Route------------------------
    route:group({before = 'manage_topics'}, function()
        route:post('topics/recommend/{id}', 'topics@recommend'):name('topics.recommend')
        route:post('topics/pin/{id}', 'topics@pin'):name('topics.pin')
        route:delete('topics/delete/{id}', 'topics@destroy'):name('topics.destroy')
        route:post('topics/sink/{id}', 'topics@sink'):name('topics.sink')
    end)
    route:group({before = 'manage_users'}, function()
        route:post('users/blocking/{id}', 'users@blocking'):name('users.blocking')
    end)
    route:post('/upload_image', 'topics@uploadImage'):name('upload_image'):bar('auth')
    -- Health Checking
    route:get('heartbeat', function()
        
        return Category.first()
    end)
    route:get('/github-api-proxy/users/{username}', 'users@githubApiProxy'):name('users.github-api-proxy')
    route:group({bar = {'auth', 'admin_auth'}}, function()
        route:get('logs', 'Rap2hpoutre.LaravelLogViewer.logviewer@index')
    end)
    ------------------ Blogs------------------------
    route:get('/blogs', 'blogs@index'):name('blogs.index')
    route:get('/blogs/create', 'blogs@create'):name('blogs.create'):bar('verified_email')
    route:post('/blogs', 'blogs@store'):name('blogs.store'):bar('verified_email')
    route:get('/blogs/{id}/edit', 'blogs@edit'):name('blogs.edit')
    route:patch('/blogs/{id}', 'blogs@update'):name('blogs.update')
    route:post('/blogs/{blog}/subscribe', 'blogs@subscribe'):name('blogs.subscribe')
    route:post('/blogs/{blog}/unsubscribe', 'blogs@unsubscribe'):name('blogs.unsubscribe')
    -- Article
    route:get("/articles/create", "articles@create"):name('articles.create'):bar('verified_email')
    route:patch("/topics/{id}/transform", "articles@transform"):name('articles.transform')
    route:post("/articles", "articles@store"):name('articles.store'):bar('verified_email')
    route:get("/articles/{id}/edit", "articles@edit"):name('articles.edit')
    route:get('/topics/{id}/{slug?}', 'topics@show'):name('topics.show')
    route:get('/articles/{id}/{slug?}', "topics@show"):name('articles.show')
    route:get('/other/{name}', 'pages@wildcard'):name('wildcard')

end

