
local lx = require('lxlib')
local fs = lx.fs

local vendorPath = lx.getPath(true)
local appPath = fs.dirname(vendorPath)
local appName = fs.basename(appPath)
local vendor = appName .. '.'

local namespace = {
	["lunit"] = vendor .. "lunit",
	["cmsgpack"] = "lxhub-cmsgpack",
	["discount"] = "lxhub-discount",
	["magick"] = vendor .. "magick",
	["lunitx"] = vendor .. "lunitx",
	["resty.http"] = vendor .. "resty.http",
	["gumbo"] = vendor .. "gumbo",
	["resty.http_headers"] = vendor .. "resty.http_headers",
	["lfs"] = "lxhub-lfs"
}

return namespace

