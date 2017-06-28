-- composer require laracasts/testdummy


local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    -- TestDummy::times(20)->create('App\Post');
end

return _M

