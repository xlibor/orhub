
local lx = require('lxlib')
local fs = lx.fs

local vendorPath = lx.getPath(true)
local appPath = fs.dirname(vendorPath)
local appName = fs.basename(appPath)
local vendor = appName .. '.'

local namespace = {
	["magick"] = vendor .. "magick",
	["resty.http_headers"] = vendor .. "resty.http_headers",
	["resty.http"] = vendor .. "resty.http",
	["lfs"] = "orhub-lfs",
	["discount"] = "orhub-discount",
	["ftcsv"] = vendor .. "ftcsv"
}

return namespace

