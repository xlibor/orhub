
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

-- Run the database seeds.


function _M:run()

    \Artisan.call('lxhub:calculate-active-user', {})
end

return _M

