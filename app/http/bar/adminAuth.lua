
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:handle(request, next)

    if not Auth.user():may('visit_admin') then
        
        return response('Unauthorized.', 401)
    end
    
    return next(request)
end

return _M

