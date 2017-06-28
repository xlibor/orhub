
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseActivity'
}

local app, lf, tb, str = lx.kit()

function _M:generate(user, topic)

    self:addTopicActivity(user, topic)
end

function _M:remove(user, topic)

    self:removeBy("u{user.id}", "t{topic.id}")
end

return _M

