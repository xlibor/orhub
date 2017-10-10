
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()
local fair = lx.h.fair

function _M:run()

    local sites = fair(Site):times(300):make()
    Site.inserts(sites:toArr())
end

return _M

