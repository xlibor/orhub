
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        type = 'xml',
        config = nil,
        sitemap = nil,
        provider = nil
    }
    
    return oo(this, mt)
end

-- The type of sitemap to build.
-- @var string
-- Config repository instance.
-- @var \Illuminate\Config\Repository
-- The sitemap generator instance.
-- @var \Roumen\Sitemap\Sitemap
-- The data provider instance.
-- @var \orhub\Sitemap\DataProvider
-- Create a new sitemap builder instance.
-- @param  \Roumen\Sitemap\Sitemap                sitemap
-- @param  \orhub\Sitemap\DataProvider  provider
-- @param  \Illuminate\Config\Repository          config


function _M:ctor(sitemap, provider, config)

    self.sitemap = sitemap
    self.provider = provider
    self.config = config
end

-- Set the type of sitemap to build.
-- @param  string  type


function _M:setType(type)

    self.type = str.lower(type)
end

-- Build the sitemap.
-- @return \Illuminate\Http\Response

function _M:render()

    if not self.sitemap:isCached() then
        self:addStaticPages()
        for type, config in pairs(self:getTypes()['custom']) do
            self:addDynamicData(type, config)
        end
    end
    
    return self.sitemap:render(self.type)
end

-- Add the static pages to the sitemap


function _M.__:addStaticPages()

    local pages = self.provider:getStaticPages()
    for _, page in pairs(pages) do
        self.sitemap:add(page['url'], nil, page['priority'], page['freq'])
    end
end

-- Get the dynamic data types.
-- @return table

function _M.__:getTypes()

    return self.config:get('sitemap')
end

-- Add the dynamic data of the given type to the sitemap.
-- @param  string  type
-- @param  table   config


function _M.__:addDynamicData(type, config)

    local lastMod
    local url
    for _, item in pairs(self:getItems(type)) do
        url = self:getItemUrl(item, type)
        lastMod = item.[config['lastMod']]
        self.sitemap:add(url, lastMod, config['priority'], config['freq'])
    end
end

-- Get the dynamic items from the data provider.
-- @param  string  type
-- @return \Illuminate\Support\Collection

function _M.__:getItems(type)

    local method = self:getDataMethodName(type)
    
    return self.provider:[method]()
end

-- Get the name of the data method.
-- @param  string  type
-- @return string

function _M.__:getDataMethodName(type)

    return 'get' .. studly_case(type)
end

-- Get the url of the given item.
-- @param  mixed   item
-- @param  string  type
-- @return string

function _M.__:getItemUrl(item, type)

    local method = self:getUrlMethodName(type)
    
    return self.provider:[method](item)
end

-- Get the name of the url method.
-- @param  string  type
-- @return string

function _M.__:getUrlMethodName(type)

    return 'get' .. studly_case(str_singular(type)) .. 'Url'
end

return _M

