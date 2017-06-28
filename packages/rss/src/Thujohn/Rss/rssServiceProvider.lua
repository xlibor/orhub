
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'serviceProvider'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        defer = false
    }
    
    return oo(this, mt)
end

-- Indicates if loading of the provider is deferred.
-- @var bool
-- Bootstrap the application events.


function _M:boot()

end

-- Register the service provider.


function _M:register()

    app:bind('rss', function(app)
        
        return new('rss')
    end)
end

-- Get the services provided by the provider.
-- @return table

function _M:provides()

    return {'rss'}
end

return _M

