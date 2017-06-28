
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'serviceProvider'
}

local app, lf, tb, str = lx.kit()

-- Register the service provider.


function _M:register()

    app:alias('sitemap', 'Roumen\\Sitemap\\Sitemap')
end

return _M

