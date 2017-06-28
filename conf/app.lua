
local lx = require('lxlib')
local env = lx.env

local conf = {
    name            = env('appName', 'lxhub'),
    debug           = env('appDebug', false),
    url             = env('appUrl'),
    urlStatic       = env('urlStatic'),
    userStatic      = env('userStatic'),
    timezone        = env('TIMEZONE') or 'Asia/Shanghai',
    locale          = env('locale') or 'en',
    key             = env('appKey', 'someRandomString'),
    namespace       = '.app.http.ctler',
    fallbackLocale  = 'en',

    boxes = {
        'lxlib.auth.authBox',
        'lxlib.cookie.cookieBox',
        'lxlib.session.sessionBox',
        'lxlib.cache.cacheBox',
        'lxlib.db.dbBox',
        'lxlib.redis.redisBox',
        'lxlib.view.viewBox',
        'lxlib.log.logBox',
        'lxlib.validation.validationBox',
        'lxlib.translation.translationBox',
        'lxlib.pagination.paginationBox',
        'lxlib.net.netBox',
        'lxlib.crypt.cryptBox',
        'lxlib.hash.hashBox',
        'lxlib.dt.dtBox',
        '.app.box.routeBox',
        '.app.box.appBox',
        '.app.box.dbBox',
        '.app.box.gatherBox',
        'lv2lx.box.viewTransBox'
    },

    faces = {
        App         = 'app',
        Auth        = 'auth',
        Cache       = 'cache@get',
        Conf        = 'config.col@get',
        Cookie      = 'cookie',
        Crypt       = 'crypt',
        Db          = 'db@table',
        Dt          = 'datetime',
        Event       = 'events',
        Fs          = {'files', nil, true},
        Gate        = 'gate',
        Hash        = 'hash@make',
        Lang        = 'translator',
        Log         = 'logger',
        Redis       = 'redis',
        Req         = 'request@input',
        Resp        = 'response',
        Route       = 'router',
        Session     = 'session.store@get',
        Validator   = 'validator',
        View        = 'view',
        Schema      = 'db.schema',
        -- Post        = '.app.model.post',
        -- User        = '.app.model.user',
        -- Comment     = '.app.model.comment',
        -- Tag         = '.app.model.tag',
        -- Category    = '.app.model.category',
        -- Page        = '.app.model.page',
        -- File        = '.app.model.file',
        -- Map         = '.app.model.map',
        -- Config      = '.app.model.config',
        -- Ip          = '.app.model.ip'
    }
}

return conf

