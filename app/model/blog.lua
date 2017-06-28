
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        guarded = {'id'}
    }
    
    return oo(this, mt)
end

function _M:user()

    return self:belongsTo(User.class)
end

function _M:subscribers()

    return self:belongsToMany(User.class, 'blog_subscribers')
end

function _M:managers()

    return self:belongsToMany(User.class, 'blog_managers')
end

function _M:topics()

    return self:belongsToMany(Topic.class, 'blog_topics')
end

function _M:authors()

    return self:belongsToMany(User.class, 'blog_authors')
end

function _M:link(params)

    params = params or {}
    
    return route('wildcard', tb.merge({self.slug}, params))
end

return _M

