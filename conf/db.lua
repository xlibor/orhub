
local lx = require('lxlib')
local env = lx.env

local conf = {
    default = 'mysql',
    connections = {
        mysql = {
            driver      = 'mysql',
            host        = env('db.host', ''),
            user        = env('db.user', ''),
            database    = 'lxhub2',
            password    = 'secret',
            port = 3306,
            pool = 5
        },
        sqlite = {
            driver = 'sqlite',
            database = lx.dir('db', 'data.db'),
        }
    },
    shift = {
        dirver = 'db',
        table = 'shift'
    }
    -- dbos =   '.db.schema.dbos'
}

return conf

