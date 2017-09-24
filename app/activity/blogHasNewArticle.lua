
local lx, _M = oo{
    _cls_ = '',
    _ext_ = '.app.activity.baseActivity'
}

local app, lf, tb, str = lx.kit()

function _M:generate(user, topic, blog)

    self:addTopicActivity(user, topic, {blog_link = blog:link(), blog_name = blog.name, blog_cover = blog.cover})
end

function _M:remove(user, topic)

    self:removeBy('u' .. user.id, 't' .. topic.id)
end

return _M

