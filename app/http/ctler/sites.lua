
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:index()

    local sites = Site.allFromCache()
    
    return view('sites.index', Compact('sites', 'banners'))
end

return _M

