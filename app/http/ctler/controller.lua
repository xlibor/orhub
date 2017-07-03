
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = {path = 'lxlib.routing.controller'},
    _mix_ = {'authorizeRequest', 'validateRequest'}
}

local app, lf, tb, str = lx.kit()

return _M

