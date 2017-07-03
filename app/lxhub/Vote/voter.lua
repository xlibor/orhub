
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

function _M:topicUpVote(topic)

    if topic:votes():byWhom(Auth.id()):withType('upvote'):count() then
        -- click twice for remove upvote
        topic:votes():byWhom(Auth.id()):withType('upvote'):delete()
        topic:decrement('vote_count', 1)
        app(UserUpvotedTopic.class):remove(Auth().user, topic)
    elseif topic:votes():byWhom(Auth.id()):withType('downvote'):count() then
        -- user already clicked downvote once
        topic:votes():byWhom(Auth.id()):withType('downvote'):delete()
        topic:votes():create({user_id = Auth.id(), is = 'upvote'})
        topic:increment('vote_count', 2)
        app(UserUpvotedTopic.class):generate(Auth().user, topic)
    else 
        -- first time click
        topic:votes():create({user_id = Auth.id(), is = 'upvote'})
        topic:increment('vote_count', 1)
        app(UserUpvotedTopic.class):generate(Auth().user, topic)
        Notification.notify('topic_upvote', Auth().user, topic.user, topic)
    end
end

function _M:topicDownVote(topic)

    if topic:votes():byWhom(Auth.id()):withType('downvote'):count() then
        -- click second time for remove downvote
        topic:votes():byWhom(Auth.id()):withType('downvote'):delete()
        topic:increment('vote_count', 1)
    elseif topic:votes():byWhom(Auth.id()):withType('upvote'):count() then
        -- user already clicked upvote once
        topic:votes():byWhom(Auth.id()):withType('upvote'):delete()
        topic:votes():create({user_id = Auth.id(), is = 'downvote'})
        topic:decrement('vote_count', 2)
    else 
        -- click first time
        topic:votes():create({user_id = Auth.id(), is = 'downvote'})
        topic:decrement('vote_count', 1)
    end
end

function _M:replyUpVote(reply)

    if Auth.id() == reply.user_id then
        
        return \Flash.warning(lang('Can not vote your feedback'))
    end
    local return = {}
    if reply:votes():byWhom(Auth.id()):withType('upvote'):count() then
        -- click twice for remove upvote
        reply:votes():byWhom(Auth.id()):withType('upvote'):delete()
        reply:decrement('vote_count', 1)
        return['action_type'] = 'sub'
        app(UserUpvotedReply.class):remove(Auth().user, reply)
    elseif reply:votes():byWhom(Auth.id()):withType('downvote'):count() then
        -- user already clicked downvote once
        reply:votes():byWhom(Auth.id()):withType('downvote'):delete()
        reply:votes():create({user_id = Auth.id(), is = 'upvote'})
        reply:increment('vote_count', 2)
        return['action_type'] = 'add'
        app(UserUpvotedReply.class):generate(Auth().user, reply)
    else 
        -- first time click
        reply:votes():create({user_id = Auth.id(), is = 'upvote'})
        reply:increment('vote_count', 1)
        return['action_type'] = 'add'
        Notification.notify('reply_upvote', Auth().user, reply.user, reply.topic, reply)
        app(UserUpvotedReply.class):generate(Auth().user, reply)
    end
    
    return return
end

return _M

