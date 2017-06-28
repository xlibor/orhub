
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:index()

    local sites = Site.allFromCache()
    local banners = Banner.allByPosition()
    
    return view('sites.index', compact('sites', 'banners'))
end

return _M

