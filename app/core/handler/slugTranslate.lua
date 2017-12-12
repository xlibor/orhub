
local _M = {
    _cls_ = ''
}

local lx = require('lxlib')
local app, lf, tb, str, new = lx.kit()

function _M.translate(text)

    if _M.isEnglish(text) then

        return str.slug(text)
    end
    local http = new('net.http.client')
    local api = 'http://api.fanyi.baidu.com/api/trans/vip/translate?'
    local appid = app:conf('service.baiduTranslate.appid')
    local salt = lf.time()
    local key = app:conf('service.baiduTranslate.key')
    -- 如果没有配置百度翻译，直接使用拼音
    if lf.isEmpty(appid) or lf.isEmpty(key) then
        
        return _M.pinyin(text)
    end
    -- http://api.fanyi.baidu.com/api/trans/product/apidoc
    -- appid+q+salt+密钥 的MD5值
    local sign = lf.md5(appid .. text .. salt .. key)
    local query = lf.httpBuildQuery({
        q = text,
        from = "zh",
        ['to'] = "en",
        appid = appid,
        salt = salt,
        sign = sign
    })
    local url = api .. query
    local response = http:get(url)
    local result = lf.jsde(response:getBody())

    local t = tb.gain(result, 'trans_result', 1, 'dst')
    if t then
        return str.slug(t)
    else 
        return _M.pinyin(text)
    end
end

function _M.pinyin(text)

    return str.slug(app(Pinyin.class):permalink(text))
end

function _M.isEnglish(text)

    if str.rematch(text, "\\p{Han}+", 'ijou') then
        
        return false
    end
    
    return true
end

return _M

