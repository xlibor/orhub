
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:show(id, request, topic)

    local category = Category.findOrFail(id)
    local topics = topic:getCategoryTopicsWithFilter(request:get('filter', 'default'), id)
    local links = Link.allFromCache()
    local banners = Banner.allByPosition()
    
    return view('topics.index', compact('topics', 'category', 'links', 'banners'))
end

return _M

