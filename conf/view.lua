
local lx = require('lxlib')
local env = lx.env

local conf = {
    engine  = 'blade',
    paths   = {
        lx.dir('res', 'view'),
        -- lx.dir('tmp', 'app/lv2lx/view'),
    },
    cache   = lx.dir('tmp', 'view'),
    extension = 'html',
    tags = {
        twig = {
            -- signBegin = '{', signEnd = '}'
        }
    }
}

return conf