
local lx = require('lxlib')
local env = lx.env

local conf = {
    default = 'mysql',
    connections = {
        mysql = {
            driver      = 'mysql',
            host        = env('db.host', ''),
            user        = env('db.user', ''),
            database    = env('db.database', ''),
            password    = env('db.password', ''),
            port        = 3306,
            poolSize    = 5,
            charset     = 'utf8mb4',
            strict      = false,
            stringSize  = 191,
        },
        lxblog = {
            driver      = 'mysql',
            host        = env('db.host', ''),
            user        = env('db.user', ''),
            database    = 'xblog3',
            password    = env('db.password', ''),
            port        = 3306,
            pool        = 2,
            charset     = 'utf8mb4',
            strict      = false,
            stringSize  = 191,
        },
        sqlite = {
            driver = 'sqlite',
            database = lx.dir('db', 'data.db'),
        }
    },
    shift = {
        dirver = 'db',
        table = 'shifts'
    }
    -- dbos =   '.db.schema.dbos'
}

return conf

