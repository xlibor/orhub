
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()
local use, lh, env = lx.use, lx.h, lx.env
local trans = lh.trans
-- local SlugTranslate = use('.app.core.handler.slugTranslate')
local pow = math.pow
local sfind, slen = string.find, string.len

-- 如：db:seed 或者 清空数据库命令的地方调用

function _M.insanity_check()

    if app:isEnv('production') then
        error('别傻了? 这是线上环境呀。')
    end
end

function _M.if_query(key, value)

    local queryValue = Req.get(key)

    if (queryValue == value)   or
        (lf.isTbl(queryValue) and tb.inList(queryValue, value)) then

        return true
    end

    return false
end

function _M.if_route(routeNames)

    local routeName = Route.currentRouteName()
    if not routeName then return false end

    if lf.isTbl(routeNames) then
        return tb.inList(routeNames, routeName)
    else
        return routeNames == routeName 
    end
end

function _M.active_class(condition, activeClass, inactiveClass)

    activeClass = activeClass or 'active'
    inactiveClass = inactiveClass or ''

    return condition and activeClass or inactiveClass
end

function _M.if_uri_pattern(patterns)

    patterns = lf.needList(patterns)

    local uri = Req().uri

    for k, p in ipairs(patterns) do
        if str.is(uri, p) then
            return true
        end
    end

    return false
end

function _M.cdn(filepath)

    do return filepath end
    
    if app:conf('app.urlStatic') then
        
        return app:conf('app.urlStatic') .. filepath
    else 
        return app:conf('app.url') .. filepath
    end
end

function _M.get_cdn_domain()

    return app:conf('app.urlStatic') or app:conf('app.url')
end

function _M.get_user_static_domain()

    return app:conf('app.userStatic') or app:conf('app.url')
end

function _M.lang(text, parameters)

    parameters = parameters or {}

    return str.replace(trans('lxhub.' .. text, parameters), 'lxhub.', '')
end

function _M.admin_link(title, path, id)

    id = id or ''
    
    return '<a href="' .. _M.admin_url(path, id) .. '" target="_blank">' .. title .. '</a>'
end

function _M.admin_url(path, id)

    id = id or ''
    
    return lx.env('appUrl') .. "/admin/{path}" .. (id and '/' .. id or '')
end

function _M.admin_enum_style_output(value, reverse)

    reverse = reverse or false
    local class
    if reverse then
        class = value == true or value == 'yes' and 'danger' or 'success'
    else 
        class = value == true or value == 'yes' and 'success' or 'danger'
    end
    
    return '<span class="label bg-' .. class .. '">' .. value .. '</span>'
end

function _M.navViewActive(anchor)

    return Route.currentRouteName() == anchor and 'active' or ''
end

function _M.model_link(title, model, id)

    return '<a href="' .. _M.model_url(model, id) .. '" target="_blank">' .. title .. '</a>'
end

function _M.model_url(model, id)

    return lx.env('appUrl') .. "/{model}/{id}"
end

function _M.per_page(default)

    local max_per_page = app:conf('api.max_per_page')
    local per_page = Req.get('per_page') or default or app:conf('api.default_per_page')
    
    return tonumber((per_page < max_per_page and per_page or max_per_page))
end

-- 生成用户客户端 URL Schema 技术的链接.

function _M.schema_url(path, parameters)

    parameters = parameters or {}
    local query = lf.isEmpty(parameters) and '' or '?' .. lf.httpBuildQuery(parameters)
    
    return str.lower(app:conf('app.name')) .. '://' .. str.trim(path, '/') .. query
end

-- formartted Illuminate\Support\MessageBag
function _M.output_msb(messageBag)

    return str.join(messageBag:all(), ", ")
end

function _M.get_platform()

    return Req.header('X-Client-Platform')
end

function _M.is_request_from_api()

    return Req().host == env('apiDomain')
end

function _M.route_class()

    return str.replace(Route.currentRouteName(), '%.', '-')
end

-- 见：https://developer.qiniu.com/dora/api/basic-processing-images-imageview2
function _M.img_crop(filepath, width, height, mode)

    filepath = filepath or ''
    mode = mode or 1
    height = height or 0
    width = width or 0
    
    if slen(filepath) > 0 then
        return filepath .. '?imageView2/' .. mode .. '/w/' .. width .. '/h/' .. height
    else
        return ''
    end
end

function _M.setting(key, default)

    default = default or ''
    local site_settings
    if not app:conf():get('settings') then
        -- Decode the settings to an associative table.
        site_settings = lf.jsde(fs.get(lx.dir('tmp', '/administrator_settings/site.json')), true)
        -- Add the site settings to the application configuration
        app:conf():set('settings', site_settings)
    end
    -- Access a setting, supplying a default value
    
    return app:conf():get('settings.' .. key, default)
end

function _M.is_route(name)

    return Req.routeIs(name)
end

function _M.get_image_links(html)

    local image_links = _M.get_images_from_html(html)
    local result = {}
    for _, url in ipairs(image_links) do
        if sfind(url, app:conf('app.urlStatic')) then
            if sfind(url, '%?') then
                url = str.str(url, '?', true)
            end
            tapd(result, url)
        end
    end
    
    return result
end

function _M.get_images_from_html(html)

    local doc = new('domDocument')
    doc:loadHtml(html)
    local img_tags = doc:getElementsByTagName('img')
    local result = {}
    for _, img in ipairs(img_tags) do
        tapd(result, img.attributes.src)
    end

    return result
end

function _M.slug_trans(word)

    return str.random(8)
    -- return SlugTranslate.translate(word)
end

-- Shortens a number and attaches K, M, B, etc. accordingly
function _M.number_shorten(number, precision, divisors)

    precision = precision or 1
    if number < 1000 then
        
        return number
    end
    -- Setup default divisors if not provided
    if not divisors then
        divisors = {
            {pow(1000, 0), ''},
            {pow(1000, 1), 'k'},
            {pow(1000, 2), 'm'},
            {pow(1000, 3), 'b'},
            {pow(1000, 4), 't'},
            {pow(1000, 5), 'Qa'},
            {pow(1000, 6), 'Qi'}
        }
    end
    -- Loop through each divisor and find the
    -- lowest amount that matches
    local divisor, shorthand
    for _, v in ipairs(divisors) do
        divisor, shorthand = v[1], v[2]
        if math.abs(number) < divisor * 1000 then
            -- We found a match!
            break
        end
    end
    -- We found our match, or there were no matches.
    -- Either way, use the last defined value for divisor.
    
    return _M.number_format(number / divisor, precision) .. shorthand
end

return _M

