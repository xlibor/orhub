
local lx = require('lxlib')
local fs = lx.fs

local vendorPath = lx.getPath(true)
local appPath = fs.dirname(vendorPath)
local appName = fs.basename(appPath)
local vendor = appName .. '.'

local namespace = {
	["cmsgpack"] = "lxhub-cmsgpack",
	["resty.http"] = vendor .. "resty.http",
	["discount"] = "lxhub-discount",
	["lfs"] = "lxhub-lfs",
	["resty.http_headers"] = vendor .. "resty.http_headers"
}

return namespace

