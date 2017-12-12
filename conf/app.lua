
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
        'lxlib.ext.socialite.socialiteBox',
        'lxlib.ext.flash.flashBox',
        'lxlib.ext.entrust.entrustBox',
        'lxlib.ext.messenger.messengerBox',
        'lxlib.dom.domBox',
        'lxlib.ext.image.imageBox',
        'lxlib.ext.tagging.taggingBox',
        'lxlib.ext.markdown.markdownBox',
        'lxlib.ext.csv.csvBox',
        '.app.box.routeBox',
        '.app.box.appBox',
        '.app.box.dbBox',
        '.app.box.authBox',
        '.app.box.gatherBox',
        'lv2lx.box.viewTransBox',
    },

    faces = {
        App         = 'app',
        Auth        = 'auth',
        Cache       = 'cache@get',
        Conf        = 'config@get',
        Cookie      = 'cookie',
        Crypt       = 'crypt',
        Db          = 'db@table',
        Dt          = 'datetime',
        Event       = 'events',
        Flash       = 'flash',
        Fs          = {'files', nil, true},
        Gate        = 'gate',
        Hash        = 'hash@make',
        Img         = 'image',
        Lang        = 'translator',
        Log         = 'logger',
        Redis       = 'redis',
        Req         = 'request',
        Resp        = 'response',
        Route       = 'router',
        Session     = 'session.store@get',
        Socialite   = 'socialite',
        Url         = 'url',
        Validator   = 'validator',
        View        = 'view',
        Schema      = 'db.schema',

        Entrust     = 'entrust',

        Ah          = {'appHelper', nil, true},
        Activity    = '.app.model.activity',
        ActiveUser  = '.app.model.activeUser',
        Append      = '.app.model.append',
        Attention   = '.app.model.attention',
        Blog        = '.app.model.blog',
        Topic       = '.app.model.topic',
        Banner      = '.app.model.banner',
        HotTopic    = '.app.model.hotTopic',
        Image       = '.app.model.image',
        Link        = '.app.model.link',
        Notification= '.app.model.notification',
        User        = '.app.model.user',
        Tag         = '.app.model.tag',
        Category    = '.app.model.category',
        Message     = '.app.model.message',
        Permission  = '.app.model.permission',
        Participant = '.app.model.participant',
        Reply       = '.app.model.reply',
        Role        = '.app.model.role',
        Site        = '.app.model.site',
        SiteStatus  = '.app.model.siteStatus',
        Thread      = '.app.model.thread',

        Vote        = '.app.model.vote',
    }
}

return conf

