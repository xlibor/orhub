
local lx, _M, mt = oo{
    _cls_ = '',
    _mix_ = 'queueable'
}

local app, lf, tb, str = lx.kit()
|--------------------------------------------------------------------------
| Queueable Jobs
|--------------------------------------------------------------------------
|
| This job base class provides a central location to place any logic that
| is shared across all of your jobs. The trait included with the class
| provides access to the "onQueue" and "delay" queue helper methods.
|

return _M

