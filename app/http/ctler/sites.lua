
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str  = lx.kit()
local use               = lx.use

local Site              = use('.app.model.site')
local Banner            = use('.app.model.banner')

function _M:index(c)

    local sites = Site.allFromCache()
    local banners = Banner.allByPosition()

    return c:view('sites.index', {sites = sites, banners = banners})
end

return _M

