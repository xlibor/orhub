
local lx = require('lxlib')
local fs = lx.fs

local vendorPath = lx.getPath(true)
local appPath = fs.dirname(vendorPath)
local appName = fs.basename(appPath)
local vendor = appName .. '.'

local namespace = {
	["ltn12"] = vendor .. "ltn12",
	["lfs"] = "lxhub-lfs",
	["cmsgpack"] = "lxhub-cmsgpack",
	["mime"] = vendor .. "mime",
	["resty.http"] = vendor .. "resty.http",
	["discount"] = "lxhub-discount",
	["resty.http_headers"] = vendor .. "resty.http_headers",
	["socket"] = vendor .. "socket"
}

return namespace

