
local lx, _M = oo{
	_cls_	= '',
	_ext_ 	= 'box'
}

local app, lf, tb, str = lx.kit()
local Banner = lx.use('.app.model.banner')

function _M:reg()

	-- app:bindNs('.app.http.gather', lx.dir('app', 'http/gather'))

end

function _M:boot()

	local view = app.view
 
    view:gather('*',    function(context)
        context.currentUser = Auth.user() or false
    end)

    view:gather({'layouts.partials.footer', 'users.index'}, function(context)

        context.banners = Banner.allByPosition()
        context.siteStat = app('.app.core.stat.stat'):getSiteStat()
    end)

    view:gather('layouts.partials.hot_tags', '.app.http.gather.hotTags')
end

return _M

