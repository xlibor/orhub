-- 如：db:seed 或者 清空数据库命令的地方调用
function insanity_check()

    if App.environment('production') then
        exit('别傻了? 这是线上环境呀。')
    end
end

function cdn(filepath)

    if config('app.url_static') then
        
        return config('app.url_static') .. filepath
    else 
        
        return config('app.url') .. filepath
    end
end

function get_cdn_domain()

    return config('app.url_static') or config('app.url')
end

function get_user_static_domain()

    return config('app.user_static') or config('app.url')
end

function lang(text, parameters)

    parameters = parameters or {}
    
    return str.replace(trans('phphub.' .. text, parameters), 'phphub.', '')
end

function admin_link(title, path, id)

    id = id or ''
    
    return '<a href="' .. admin_url(path, id) .. '" target="_blank">' .. title .. '</a>'
end

function admin_url(path, id)

    id = id or ''
    
    return env('APP_URL') .. "/admin/{path}" .. (id and '/' .. id or '')
end

function admin_enum_style_output(value, reverse)

    reverse = reverse or false
    local class
    if reverse then
        class = value == true or value == 'yes' and 'danger' or 'success'
    else 
        class = value == true or value == 'yes' and 'success' or 'danger'
    end
    
    return '<span class="label bg-' .. class .. '">' .. value .. '</span>'
end

function navViewActive(anchor)

    return Route.currentRouteName() == anchor and 'active' or ''
end

function model_link(title, model, id)

    return '<a href="' .. model_url(model, id) .. '" target="_blank">' .. title .. '</a>'
end

function model_url(model, id)

    return env('APP_URL') .. "/{model}/{id}"
end

function per_page(default)

    local max_per_page = config('api.max_per_page')
    local per_page = Input.get('per_page') or default or config('api.default_per_page')
    
    return tonumber((per_page < max_per_page and per_page or max_per_page))
end

-- 生成用户客户端 URL Schema 技术的链接.

function schema_url(path, parameters)

    parameters = parameters or {}
    local query = lf.isEmpty(parameters) and '' or '?' .. lf.httpBuildQuery(parameters)
    
    return str.lower(config('app.name')) .. '://' .. str.trim(path, '/') .. query
end

-- formartted Illuminate\Support\MessageBag
function output_msb(messageBag)

    return str.join(messageBag:all(), ", ")
end

function get_platform()

    return Request.header('X-Client-Platform')
end

function is_request_from_api()

    return _SERVER['SERVER_NAME'] == env('API_DOMAIN')
end

function route_class()

    return str.replace(Route.currentRouteName(), '.', '-')
end

-- 见：https://developer.qiniu.com/dora/api/basic-processing-images-imageview2
function img_crop(filepath, width, height, mode)

    mode = mode or 1
    height = height or 0
    width = width or 0
    
    return filepath .. "?imageView2/{mode}/w/{width}/h/{height}"
end

function setting(key, default)

    default = default or ''
    local site_settings
    if not config():get('settings') then
        -- Decode the settings to an associative table.
        site_settings = lf.jsde(file_get_contents(storage_path('/administrator_settings/site.json')), true)
        -- Add the site settings to the application configuration
        config():set('settings', site_settings)
    end
    -- Access a setting, supplying a default value
    
    return config():get('settings.' .. key, default)
end

function is_route(name)

    return Request.route():getName() == name
end

function get_image_links(html)

    local image_links = get_images_from_html(html)
    local result = {}
    for _, url in pairs(image_links) do
        if str.strpos(url, config('app.url_static')) ~= false then
            tapd(result, strtok(url, '?'))
        end
    end
    
    return result
end

function get_images_from_html(html)

    local doc = new('dOMDocument')
    @doc:loadHTML(html)
    local img_tags = doc:getElementsByTagName('img')
    local result = {}
    for _, img in pairs(img_tags) do
        tapd(result, img:getAttribute('src'))
    end
    
    return result
end

function slug_trans(word)

    return Phphub\Handler\SlugTranslate.translate(word)
end

-- Shortens a number and attaches K, M, B, etc. accordingly
function number_shorten(number, precision, divisors)

    precision = precision or 1
    if number < 1000 then
        
        return number
    end
    -- Setup default divisors if not provided
    if not divisors then
        divisors = {
            ['pow(1000, 0)'] = '',
            ['pow(1000, 1)'] = 'k',
            ['pow(1000, 2)'] = 'm',
            ['pow(1000, 3)'] = 'b',
            ['pow(1000, 4)'] = 't',
            ['pow(1000, 5)'] = 'Qa',
            ['pow(1000, 6)'] = 'Qi'
        }
    end
    -- Loop through each divisor and find the
    -- lowest amount that matches
    for divisor, shorthand in pairs(divisors) do
        if abs(number) < divisor * 1000 then
            -- We found a match!
            break
        end
    end
    -- We found our match, or there were no matches.
    -- Either way, use the last defined value for divisor.
    
    return number_format(number / divisor, precision) .. shorthand
end