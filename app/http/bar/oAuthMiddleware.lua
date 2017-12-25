
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        authorizer = nil,
        auth = nil,
        router = nil
    }
    
    return oo(this, mt)
end

-- Create a new auth middleware instance.
-- @param \Dingo\Api\Routing\Router router
-- @param \Dingo\Api\Auth\Auth      auth
-- @param Authorizer                authorizer

function _M:ctor(router, auth, authorizer)

    self.router = router
    self.auth = auth
    self.authorizer = authorizer
end

-- Handle an incoming request.
-- @param \Illuminate\Http\Request                request
-- @param func|\lxhub\Http\Middleware\Closure next
-- @param type
-- @return mixed
-- @throws AccessDeniedException

function _M:handle(request, next, type)

    local route = self.router:getCurrentRoute()
    if not self.auth:check(false) then
        self.auth:authenticate(route:getAuthenticationProviders())
    end
    self.authorizer:setRequest(request)
    --type: user or client
    if type and self.authorizer:getResourceOwnerType() ~= type then
        lx.throw(AccessDeniedException)
    end
    
    return next(request)
end

return _M

