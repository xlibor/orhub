
local lx = require('lxlib')
local str, env = lx.str, lx.env
local appUrl = str.finish(env('appUrl'), '/')

local conf = {
    github = {
        driver = 'github',
        client_id = env('github.clientId'),
        client_secret = env('github.clientSecret'),
        redirect = appUrl .. 'auth/callback?driver=github'
    },
    qq = {
        driver = 'qq',
        client_id = env('qq.clientId'),
        client_secret = env('qq.clientSecret'),
        redirect = appUrl .. 'auth/callback?driver=qq'
    },
    wechat = {
        driver = 'wechat',
        client_id = env('wechat.appId'),
        client_secret = env('wechat.appSecret'),
        redirect = appUrl .. 'auth/callback?driver=wechat',
        auth_base_uri = 'https://open.weixin.qq.com/connect/qrconnect'
    },
    baiduTranslate = {
        appid = env('baidu.translate_appid'),
        key = env('baidu.translate_key')
    },
    mailgun = {
        domain = env('MAILGUN_DOMAIN'),
        secret = env('MAILGUN_SECRET')
    },
}

return conf

