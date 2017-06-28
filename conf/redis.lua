
local lx = require('lxlib')

local conf = {
	cluster = false,
	default = 'default',
	connections = {
		default =	{
			host		= '127.0.0.1',
			password	= nil,
			port		= 6379,
			database	= 0
		},
		session = {
			host		= '127.0.0.1',
			password	= nil,
			port		= 6379,
			database	= 1
		},
	}
}

return conf

