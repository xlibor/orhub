
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = '.app.activity.baseActivity'
}

local app, lf, tb, str = lx.kit()

function _M:generate(user, topic, append)

    self:addTopicActivity(user, topic, {body = append.content})
end

return _M

