
local lx, _M, mt = oo{
    _cls_ = '',
    _mix_ = 'handlesAuthorization'
}

local app, lf, tb, str = lx.kit()
function _M:show_draft(user, topic)

    return user:may('manage_topics') or topic.user_id == user.id
end

function _M:update(user, topic)

    return user:may('manage_topics') or topic.user_id == user.id
end

function _M:delete(user, topic)

    return user:may('manage_topics') or topic.user_id == user.id
end

function _M:recommend(user, topic)

    return user:may('manage_topics')
end

function _M:wiki(user, topic)

    return user:may('manage_topics')
end

function _M:pin(user, topic)

    return user:may('manage_topics')
end

function _M:sink(user, topic)

    return user:may('manage_topics')
end

function _M:append(user, topic)

    return user:may('manage_topics') or topic.user_id == user.id
end

return _M

