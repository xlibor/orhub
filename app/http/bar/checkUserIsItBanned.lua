
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:handle(request, next)

    if Auth.check() and Auth().user.is_banned == 'yes' and Req.is('user-banned') == false then
        
        return redirect('/user-banned')
    end
    
    return next(request)
end

return _M

