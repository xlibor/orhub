
local lx = require('lxlib')

local conf = {
    driver          = 'db',
    enable          = false,
    prefix          = 'lxblog',
    lock            = {
        auto        = true,
        shdict      = 'lxCache',
        pttl        = 10,
        nttl        = 3
    },
    stores          = {
        file            = {
            driver      = 'file',
            path        = lx.dir('tmp', 'lib/cache')
        },
        db              = {
            driver      = 'db',
            connection  = nil,
            table       = 'cache'
        },
        redis           = {
            driver      = 'redis',
            connection  = 'default'
        },
        arr             = {
            driver      = 'arr'
        }
    }
}

return conf

