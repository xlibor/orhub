
local lx = require('lxlib')

local conf = {
    driver          = 'db',
    lifetime        = 1,
    expireOnClose   = true,
    encrypt         = false,
    lottery         = {2,100},
    cookie          = 'lxsid',
    path            = '/',
    domain          = '',
    secure          = false,
    store           = nil,
    drivers         = {
        file            = {
            driver      = 'file',
            path        = lx.dir('tmp', 'lib/session')
        },
        db              = {
            driver      = 'db',
            connection  = nil,
            table       = 'sessions'
        },
        cookie          = {
            driver      = 'cookie'
        },
        cache           = {
            driver      = 'redis',
            connection  = 'session'
        }
    }
}

return conf

