
local lx = require('lxlib')
local env = lx.env

local conf = {
    default     = 'file',
    fileName    = lx.dir('tmp', 'log/lxlib.log'),
    formatter   = 'line',
    handlers    = {
        daily   = {
            driver      = 'dailyFile',
            level       = 'debug',
            maxFiles    = 0,
            bubble      = true,
        },
        file    = {
            driver      = 'file',
            level       = 'debug',
            bubble      = true,
        }
    }
}

return conf

