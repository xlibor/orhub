
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

-- Run the database seeds.


function _M:run()

    local sites = factory(Site.class):times(300):make()
    Site.insert(sites:toArray())
end

return _M

