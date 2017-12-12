
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    -- _bond_ = 'creatorListener',
}

local app, lf, tb, str, new = lx.kit()
local use, try, lh, fs      = lx.use, lx.try, lx.h, lx.fs
local redirect              = lh.redirect
local lang                  = Ah.lang

local Topic                 = use('.app.model.topic')
local Tag                   = use('.app.model.tag')

function _M:ctor()

    self:setBar('auth', {except = {'index', 'show', 'topics'}})
end

function _M:topics(c, tagName)

    local request = c.req
    local tag = new(Tag):byTagName(tagName):first()

    local topics = new(Topic):getTaggedTopicsWithFilter(request:get('filter', 'default'), tag)
    local links = Link.allFromCache()
    
    c:view('topics.index', Compact('topics', 'tag', 'category', 'links', 'banners'))
end

function _M:show(c, id, slug)

    local request = c.req

    local tag = Tag.find(id)
    echo(tag)

end


return _M

