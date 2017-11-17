
return function(fair)
    
    local lx = require('lxlib')
    local app, lf, tb, str, new = lx.kit()
    local use = lx.ns('.app.model')
    local User, Topic, Reply, Site = use(
        'user', 'topic', 'reply', 'site'
    )

    local rand = lf.rand

    fair:define(User, function(faker)
        
        return {
            github_url = faker:url(),
            city = faker:city(),
            name = faker:userName(),
            github_name = faker:userName(),
            twitter_account = faker:userName(),
            company = faker:userName(),
            personal_website = faker:url(),
            image_url = faker:url(),
            introduction = faker:sentence(),
            certification = faker:sentence(),
            email = faker:email(),
            password = 'secret',
            verified = true,
            login_token = 'uDFDJys7iwM0fTXuLNNH',
            -- avatar = '',
            created_at = lf.datetime(),
            updated_at = lf.datetime()
        }
    end)
    fair:define(Topic, function(faker)
        
        return {
            title = faker:sentence(),
            body = faker:text(),
            created_at = lf.datetime(),
            updated_at = lf.datetime()
        }
    end)
    fair:define(Reply, function(faker)
        body = faker:text()
        
        return {
            body = body,
            body_original = body,
            created_at = lf.datetime(),
            updated_at = lf.datetime()
        }
    end)
    fair:define(Site, function(faker)
        
        return {
            title = faker:userName(),
            description = faker:sentence(),
            type = faker:randomElement({'site', 'blog', 'weibo', 'dev_service'}),
            favicon = '/assets/images/favicon.png',
            link = faker:url(),
            created_at = lf.datetime(),
            updated_at = lf.datetime()
        }
    end)
end

