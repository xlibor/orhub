
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'model',
    _static_    = {}
}

local app, lf, tb, str = lx.kit()

function _M:post()

    return self:belongsTo('Post')
end

function _M:user()

    return self:belongsTo('User')
end

function _M.s__.isUserAttentedTopic(user, topic)

    return Attention.where('user_id', user.id):where('topic_id', topic.id):first()
end

return _M

