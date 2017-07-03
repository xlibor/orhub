-- 为了兼容 API 的写法
-- {{url}}/topics?include=node,last_reply_user,user&filter=jobs&per_page=15&page=1


local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:last_reply_user()

    return self:belongsTo(User, 'last_reply_user_id')
end

function _M:node()

    return self:belongsTo(Category)
end

return _M

