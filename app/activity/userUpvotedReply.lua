
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseActivity'
}

local app, lf, tb, str = lx.kit()

function _M:generate(user, reply)

    self:addTopicActivity(user, reply.topic, {
        body = reply.body,
        reply_id = reply.id,
        reply_user_id = reply.user.id,
        reply_user_name = reply.user.name
    }, "r{reply.id}")
end

function _M:remove(user, reply)

    self:removeBy("u{user.id}", "r{reply.id}")
end

return _M

