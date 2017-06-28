
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        url = nil,
        topics = nil,
        categories = nil
    }
    
    return oo(this, mt)
end

-- The URL generator instance.
-- @var \Illuminate\Routing\UrlGenerator
-- Topic Eloquent Model
-- @var \Topic
-- Catebory Eloquent Model
-- @var \Category
-- Create a new data provider instance.
-- @param  \Illuminate\Routing\UrlGenerator  url
-- @param  \Topic                            topics
-- @param  \Category                         categories


function _M:ctor(url, topics, categories)

    self.url = url
    self.topics = topics
    self.categories = categories
end

-- Get all the topic to include in the sitemap.
-- @return \Illuminate\Database\Eloquent\Collection|\Topic[]

function _M:getTopics()

    return self.topics:recent():get()
end

-- Get the url for the given topic.
-- @param  \Topic  topic
-- @return string

function _M:getTopicUrl(topic)

    return topic:link()
end

-- Get all the Categories to include in the sitemap.
-- @return \Illuminate\Database\Eloquent\Collection|\Category[]

function _M:getCategories()

    return self.categories:orderBy('created_at', 'desc'):get()
end

-- Get the url for the given category.
-- @param  \Category category
-- @return string

function _M:getCategoryUrl(category)

    return self.url:route('categories.show', category.id)
end

-- Get all the static pages to include in the sitemap.
-- @return table

function _M:getStaticPages()

    local static = {}
    tapd(static, self:getPage('home', 'daily', '1.0'))
    tapd(static, self:getPage('topics.index', 'daily', '1.0'))
    tapd(static, self:getPage('users.index', 'weekly', '0.8'))
    tapd(static, self:getPage('about', 'monthly', '0.7'))
    
    return static
end

-- Get the data for the given page.
-- @param  string  route
-- @param  string  freq
-- @param  string  priority
-- @return table

function _M.__:getPage(route, freq, priority)

    local url = self.url:route(route)
    
    return compact('url', 'freq', 'priority')
end

return _M

