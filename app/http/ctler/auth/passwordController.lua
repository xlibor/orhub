
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    _mix_ = 'resetsPasswords'
}

local app, lf, tb, str = lx.kit()
|--------------------------------------------------------------------------
| Password Reset Controller
|--------------------------------------------------------------------------
|
| This controller is responsible for handling password reset requests
| and uses a simple trait to include this behavior. You're free to
| explore this trait and override any methods you wish to tweak.
|
-- Create a new password controller instance.


function _M:ctor()

    self:middleware('guest')
end

return _M

