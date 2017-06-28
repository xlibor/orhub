
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'serviceProvider'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        listen = {['App\\Events\\SomeEvent'] = {'App\\Listeners\\EventListener'}, ['\SocialiteProviders\Manager\SocialiteWasCalled.class'] = {'SocialiteProviders\\Weixin\\WeixinExtendSocialite@handle'}}
    }
    
    return oo(this, mt)
end

-- The event listener mappings for the application.
-- @var table
-- Register any other events for your application.
-- @param  \Illuminate\Contracts\Events\Dispatcher  events


function _M:boot(events)

    parent.boot(events)
    --
end

return _M

