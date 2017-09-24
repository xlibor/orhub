
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = '.app.activity.baseActivity'
}

local app, lf, tb, str = lx.kit()
local route = lx.h.route

function _M:generate(user, following)

    local causer = 'u' .. user.id
    local indentifier = 'u' .. following.id
    local data = tb.merge({
        following_name = following.name,
        following_link = route('users.show', following.id)})
    self:addActivity(causer, user, indentifier, data)
end

function _M:remove(user, following)

    self:removeBy('u' .. user.id, 'u' .. following.id)
end

return _M

