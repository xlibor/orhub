
local lx = require('lxlib')

local conf = {
	driver			= 'sha',
 	hashers			= {
 		sha			= {
 			driver 		= 'sha',
 			level		= 1
 		},
 		md5			= {
 			driver		= 'md5'
 		}
 	}
}

return conf

