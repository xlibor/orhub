
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
 	app:bind('.app.lxhub.stat.stat')
 	app:single('appHelper', 		'.app.mod.appHelper')
 	app:bind('socialiteHelper', 	'.app.mod.socialiteHelper')
	app:bond('creatorListener', 	'.app.lxhub.core.creatorListener')
 	app:bindNs('.app.http.ctler', 			lx.dir('app', 'http/ctler'))
 	app:bindNs('.app.http.req', 			lx.dir('app', 'http/req'))
 	app:bindNs('.app.policy', 				lx.dir('app', 'policy'))
	app:bindNs('.app.lxhub.presenter', 		lx.dir('app', 'lxhub/presenter'))
	app:bindNs('.app.lxhub.creator', 		lx.dir('app', 'lxhub/creator'))
	app:bindNs('.app.lxhub.notification', 	lx.dir('app', 'lxhub/notification'))
	app:bindNs('.app.lxhub.markdown', 		lx.dir('app', 'lxhub/markdown'))
	app:bindNs('.app.activity', 			lx.dir('app', 'activity'))
	app:bindNs('.app.lxhub.handler', 		lx.dir('app', 'lxhub/handler'))
end

function _M:boot()

	-- Dt.setLocale('zh')

	if app:isCmdMode() then
		-- app:reg('laralib.l5scaffold.generatorBox')
	end
end

return _M

