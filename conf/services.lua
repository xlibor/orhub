
local lx = require('lxlib')
local str, env = lx.str, lx.env

local conf = {
    github = {
        driver = 'github',
        client_id = env('github.clientId'),
        client_secret = env('github.clientSecret'),
        redirect = str.finish(env('appUrl'), '/') .. 'auth/callback?driver=github'
    },
    weixin = {
        client_id = env('WEIXIN_KEY'),
        client_secret = env('WEIXIN_SECRET'),
        redirect = env('WEIXIN_REDIRECT_URI'),
        auth_base_uri = 'https://open.weixin.qq.com/connect/qrconnect'
    },
    baidu_translate = {
        appid = env('BAIDU_TRANSLATE_APPID'),
        key = env('BAIDU_TRANSLATE_KEY')
    },
    mailgun = {
        domain = env('MAILGUN_DOMAIN'),
        secret = env('MAILGUN_SECRET')
    },
}

return conf

