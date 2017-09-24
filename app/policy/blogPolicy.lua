
local lx, _M, mt = oo{
    _cls_ = '',
    _mix_ = 'handleAuthorization'
}

local app, lf, tb, str = lx.kit()

function _M:update(user, blog)

    return user:isAuthorOf(blog)
end

function _M:manage(user, blog)

    return blog:managers():where('user_id', user.id):count() > 0
end

function _M:createArticle(user, blog)

    return user:isAuthorOf(blog) or Gate.allows('manage', blog)
end

return _M

