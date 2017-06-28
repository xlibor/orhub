
local lx = require('lxlib')

local conf = {
    driver              = 'aes',
    crypters = {
        aes = {
            driver      = 'aes',
            cipher      = {'cbc', 256},
            hash        = {'sha256', 5},
            -- hash        = {iv = function()
            --     return lx.str.random(16)
            -- end},
            padding = 0
        },
    }

}

return conf

