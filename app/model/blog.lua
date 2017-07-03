
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.guarded = {'id'}
end

function _M:user()

    return self:belongsTo(User)
end

function _M:subscribers()

    return self:belongsToMany(User, 'blog_subscribers')
end

function _M:managers()

    return self:belongsToMany(User, 'blog_managers')
end

function _M:topics()

    return self:belongsToMany(Topic, 'blog_topics')
end

function _M:authors()

    return self:belongsToMany(User, 'blog_authors')
end

function _M:link(params)

    params = params or {}
    
    return route('wildcard', tb.merge({self.slug}, params))
end

return _M

