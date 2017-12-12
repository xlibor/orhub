
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()
local lh = lx.h
local response, redirect = lh.response, lh.redirect

function _M:handle(c, next)

    local request = c.req
    if Auth.guest() then
        if request.ajax then
            
            return response('Unauthorized.', 401)
        else 
            
            return redirect():guest('login-required')
        end
    end
    
    return next(c)
end

return _M

