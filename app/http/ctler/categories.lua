
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:show(c, id)

    local request = c.req
    local category = Category.findOrFail(id)
    local topics = Topic.getCategoryTopicsWithFilter(request:get('filter', 'default'), id)
    local links = Link.allFromCache()
    
    c:view('topics.index', {
        topics = topics, category = category,
        links = links, banners = banners
    })
end

return _M

