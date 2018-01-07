
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
            pool        = 5,
            charset     = 'utf8mb4',
            strict      = false,
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

