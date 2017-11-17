
local lx = require('lxlib')
local env = lx.env

local conf = {
	bladeTrans = {
		srcDir = '/vagrant/webroot/myprj/storage/app/lv2lx/php/laravel-admin/resources/views',
		saveDir = lx.dir('tmp', 'app/lv2lx/view')
	}
}

return conf

