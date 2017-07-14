
local lx, _M = oo{
	_cls_	= '',
	_ext_ 	= 'box'
}

local app, lf, tb, str = lx.kit()

function _M:reg()

	-- app:bindNs('.app.http.gather', lx.dir('app', 'http/gather'))

end

function _M:boot()

	local view = app.view
 
    view:gather('*',    function(context)
        context.currentUser = Auth.user()
    end)

    view:gather({'layouts.partials.footer', 'users.index'}, function(context)

        context.banners = Banner.allByPosition()
        context.siteStat = app('.app.lxhub.stat.stat'):getSiteStat()
    end)
end

return _M

