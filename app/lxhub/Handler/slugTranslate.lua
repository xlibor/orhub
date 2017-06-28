
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M.s__.translate(text)

    if static.isEnglish(text) then
        
        return str_slug(text)
    end
    local http = new('client')
    local api = 'http://api.fanyi.baidu.com/api/trans/vip/translate?'
    local appid = config('services.baidu_translate.appid')
    local salt = time()
    local key = config('services.baidu_translate.key')
    -- 如果没有配置百度翻译，直接使用拼音
    if lf.isEmpty(appid) or lf.isEmpty(key) then
        
        return static.pinyin(text)
    end
    -- http://api.fanyi.baidu.com/api/trans/product/apidoc
    -- appid+q+salt+密钥 的MD5值
    local sign = md5(appid .. text .. salt .. key)
    local query = lf.httpBuildQuery({
        ['"q"'] = text,
        ['"from"'] = "zh",
        ['"to"'] = "en",
        ['"appid"'] = appid,
        ['"salt"'] = salt,
        ['"sign"'] = sign
    })
    local url = api .. query
    local response = http:get(url)
    local result = lf.jsde(response:getBody(), true)
    if result['trans_result'][0]['dst'] then
        
        return str_slug(result['trans_result'][0]['dst'])
    else 
        
        return static.pinyin(text)
    end
end

function _M.s__.pinyin(text)

    return str_slug(app(Pinyin.class):permalink(text))
end

function _M.s__.isEnglish(text)

    if str.rematch(text, "/\\p{Han}+/u") then
        
        return false
    end
    
    return true
end

return _M

