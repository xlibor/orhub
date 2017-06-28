
local lx = require('lxlib')

local autoload = lx.f.prequire('.vendor.lxcarrier.autoload')
if autoload then
	local global = require('lxlib.base.global')

	global.addNamespaces(autoload)
end

return autoload