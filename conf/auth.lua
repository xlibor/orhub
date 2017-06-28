
local lx = require('lxlib')

local conf = {
    defaults = {
        guard       = 'web',
        passwords   = 'users'
    },
    guards = {
        web = {
            driver      = 'session',
            provider    = 'users'
        },
        api = {
            driver      = 'passport',
            provider    = 'users'
        }
    },
    providers = {
        users = {
            driver      = 'orm',
            model       = '.app.model.user',
            table       = 'users'
        }
    },
    passwords = {
        users = {
            provider    = 'users',
            table       = 'password_resets',
            expire      = 60
        }
    }
}

return conf

