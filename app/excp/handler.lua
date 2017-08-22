
local lx, _M = oo{
    _cls_ = '',
    _ext_ = {path = 'lxlib.exception.handler'}
}

local redirect, route = lx.h.redirect, lx.h.route

function _M:ctor()

    self.dontReport = {
        'authenticationException',
        'authorizationException',
        'httpException',
        'modelNotFoundException',
        'tokenMismatchException',
        'validationException',
    }
end

function _M:unauthenticated(ctx, e)

    local req = ctx.req

    if req.wantsJson then
        ctx:json({error = 'Unauthenticated'}, 401)
    else
        redirect():guest(route('login'))
    end
end

return _M

