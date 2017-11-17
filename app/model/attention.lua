
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'model',
    _static_    = {}
}

local app, lf, tb, str, new = lx.kit()

function _M:post()

    return self:belongsTo('.app.model.post')
end

function _M:user()

    return self:belongsTo('.app.model.user')
end

function _M.s__.isUserAttentedTopic(user, topic)

    return new('.app.model.attention'):where('user_id', user.id):where('topic_id', topic.id):first()
end

return _M

