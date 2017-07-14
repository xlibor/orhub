
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:handle(request, next)

    if Auth.check() and Req.is('notifications/count') == false then
        Auth.user():recordLastActivedAt()
    end
    
    return next(request)
end

return _M

