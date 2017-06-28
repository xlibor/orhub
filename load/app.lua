
require('.load.autoload')

local lx = require('lxlib')

local scaffold = {
	app 	= 'app',
	conf	= 'conf',
	db		= 'db',
	map		= 'map',
	pub		= 'pub',
	res		= 'res',
	tmp		= 'tmp',
    test    = 'test'
}

local app = lx.n.app(scaffold)

lx.h = require('lxlib.app.helper')

app:single('http.kernel',		'.app.http.kernel')
app:single('console.kernel',	'.app.cmd.kernel')

require('.load.global')

return app

