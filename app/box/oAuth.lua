
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'serviceProvider'
}

local app, lf, tb, str = lx.kit()

function _M:boot()

    app[DingoAuth.class]:extend('oauth', function(app)
        provider = new('oAuth2', app['oauth2-server.authorizer']:getChecker())
        provider:setUserResolver(function(id)
            Auth.loginUsingId(id)
            
            return User.findOrFail(id)
        end)
        provider:setClientResolver(function(id)
            --TODO: Logic to return a client by their ID.
        end)
        
        return provider
    end)
end

function _M:register()

    --
end

return _M

