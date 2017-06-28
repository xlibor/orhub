
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        notifiedUsers = {}
    }
    
    return oo(this, mt)
end

function _M:newTopicNotify(fromUser, mentionParser, topic)

    -- Notify mentioned users
    Notification.batchNotify('mentioned_in_topic', fromUser, self:removeDuplication(mentionParser.users), topic)
    -- Notify user follower
    Notification.batchNotify('new_topic_from_following', fromUser, self:removeDuplication(fromUser.followers), topic)
    -- Notify blog subscriber
    if #topic.user.blogs then
        Notification.batchNotify('new_topic_from_subscribe', fromUser, self:removeDuplication(topic.user.blogs:first().subscribers), topic)
    end
end

function _M:newReplyNotify(fromUser, mentionParser, topic, reply)

    -- Notify the author
    Notification.batchNotify('new_reply', fromUser, self:removeDuplication({topic.user}), topic, reply)
    -- Notify attented users
    Notification.batchNotify('attention', fromUser, self:removeDuplication(topic:attentedUsers()), topic, reply)
    -- Notify mentioned users
    Notification.batchNotify('at', fromUser, self:removeDuplication(mentionParser.users), topic, reply)
end

function _M:newAppendNotify(fromUser, topic, append)

    local users = topic:replies():with('user'):get():lists('user')
    -- Notify commented user
    Notification.batchNotify('comment_append', fromUser, self:removeDuplication(users), topic, nil, append.content)
    -- Notify voted users
    Notification.batchNotify('vote_append', fromUser, self:removeDuplication(topic:votedUsers()), topic, nil, append.content)
    -- Notify attented users
    Notification.batchNotify('attented_append', fromUser, self:removeDuplication(topic:attentedUsers()), topic, nil, append.content)
end

function _M:newFollowNotify(fromUser, toUser)

    Notification.notify('follow', fromUser, toUser, nil, nil, nil)
end

-- in case of a user get a lot of the same notification
function _M:removeDuplication(users)

    local notYetNotifyUsers = {}
    for _, user in pairs(users) do
        if not tb.inList(self.notifiedUsers, user.id) then
            tapd(notYetNotifyUsers, user)
            tapd(self.notifiedUsers, user.id)
        end
    end
    
    return notYetNotifyUsers
end

return _M

