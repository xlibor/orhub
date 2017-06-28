
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseActivity'
}

local app, lf, tb, str = lx.kit()

function _M:generate(user, blog)

    local causer = 'u' .. user.id
    local indentifier = 'b' .. blog.id
    local data = tb.merge({blog_name = blog.name, blog_link = blog:link()})
    self:addActivity(causer, user, indentifier, data)
end

function _M:remove(user, blog)

    self:removeBy("u{user.id}", "b{blog.id}")
end

return _M

