
local lx, _M = oo{
	_cls_	= '',
	_ext_ 	= 'box'
}

local app, lf, tb, str, new = lx.kit()
local Dt = lx.use('datetime')

function _M:reg()

	app:bind('context', 			'.app.http.context')
	app:bind('controller', 			'.app.http.ctler.controller')
	app:bind('exception.handler', 	'.app.excp.handler')

	app:single('.app.http.bar.verifyCsrfToken')
	app:single('.app.http.bar.redirectIfAuthenticated')
	app:bind('baseFormRequest', '.app.http.req.request')
 	app:single('appHelper', 		'.app.mod.appHelper')
 	app:bind('socialiteHelper', 	'.app.mod.socialiteHelper')
	app:bond('creatorListener', 	'.app.lxhub.core.creatorListener')

end

function _M:boot()

	-- Dt.setLocale('zh')

	if app:isCmdMode() then
		-- app:reg('laralib.l5scaffold.generatorBox')
	end
end

return _M

