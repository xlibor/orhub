
return function(route)
    
    local lx = require('lxlib')
    local app = lx.app()

    -- 申请 access_token 或者刷新 access_token.

    route:post('oauth/access_token', 'oauth@issueAccessToken')
    --  此分组下路由 需要通过 login-token 方式认证的 access token

    route:group({bar = 'oauth2:user'}, function(route)
        -- 发布内容单独设置频率限制
        route:group({bar = 'api.throttle', limit = app:conf('api.rate_limits.publish.limits'), expires = app:conf('api.rate_limits.publish.expires')}, function(route)
            route:post('topics', 'topics@store')
            route:post('replies', 'replies@store')
        end)
        route:group({bar = 'api.throttle', limit = app:conf('api.rate_limits.access.limits'), expires = app:conf('api.rate_limits.access.expires')}, function(route)
            -- Users
            route:get('me', 'users@me')
            route:put('users/{id}', 'users@update')
            -- Topics
            route:delete('topics/{id}', 'topics@destroy')
            route:post('topics/{id}/vote-up', 'topics@voteUp')
            route:post('topics/{id}/vote-down', 'topics@voteDown')
            -- Notifications
            route:get('me/notifications', 'notification@index')
            route:get('me/notifications/count', 'notification@unreadMessagesCount')
        end)
    end)
    -- 此分组下路由 同时支持两种认证方式获取的 access_token

    route:group({bar = {'oauth2', 'api.throttle'}, limit = app:conf('api.rate_limits.access.limits'), expires = app:conf('api.rate_limits.access.expires')}, function(route)
        route:get('topics/{id}', 'topics@show')
        --Topics
        route:get('topics', 'topics@index')
        route:get('user/{id}/votes', 'topics@indexByUserVotes')
        route:get('user/{id}/topics', 'topics@indexByUserId')
        --Web Views
        route:get('topics/{id}/web_view', {as = 'topic.web_view', uses = 'topics@showWebView'})
        route:get('topics/{id}/replies/web_view', {as = 'replies.web_view', uses = 'replies@indexWebViewByTopic'})
        route:get('users/{id}/replies/web_view', {as = 'users.replies.web_view', uses = 'replies@indexWebViewByUser'})
        route:get('categories', 'categories@index')
        --Replies
        route:get('topics/{id}/replies', 'replies@indexByTopicId')
        route:get('users/{id}/replies', 'replies@indexByUserId')
        --Users
        route:get('users/{id}', 'users@show')
        --Adverts
        route:get('adverts/launch_screen', 'launchScreenAdverts@index')
    end)

end