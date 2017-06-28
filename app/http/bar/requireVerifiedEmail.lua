
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:handle(request, next)

    if Auth.check() and not Auth.user().verified then
        
        return redirect(route('email-verification-required'))
    end
    
    return next(request)
end

return _M

