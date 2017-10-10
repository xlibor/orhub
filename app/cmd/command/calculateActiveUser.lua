
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

local PostTopicWeight = 4
local PostReplyWeight = 1
local PassDays = 7

function _M:ctor()

    self.description = 'calculate active user'
end

function _M:run()

    ActiveUser.query():delete()
    self:calculateTopicUsers()
    self:calculateReplyUsers()
    self:calculateWeight()

    self:info(self.description)
end

function _M.__:calculateTopicUsers()

    local data
    local topic_users = Topic.query()
        :select('user_id', {'*', 'topic_count', 'count'})
        :where('created_at', '>=', Dt.now():subDays(PassDays))
        :groupBy('user_id')
        :get()
    
    for _, value in ipairs(topic_users) do
        data = {}
        data.user_id = value.user_id
        data.topic_count = value.topic_count
        ActiveUser.updateOrCreate({user_id = value.user_id}, data)
    end
end

function _M.__:calculateReplyUsers()

    local data
    local reply_users = Reply.query():select(
            'user_id', {'*', 'reply_count', 'count'}
        )
        :where('created_at', '>=', Dt.now():subDays(PassDays))
        :groupBy('user_id')
        :get()

    for _, value in ipairs(reply_users) do
        data = {}
        data.user_id = value.user_id
        data.reply_count = value.reply_count
        ActiveUser.updateOrCreate({user_id = value.user_id}, data)
    end
end

function _M.__:calculateWeight()

    local active_users = ActiveUser.all()
    for _, active_user in ipairs(active_users) do
        active_user.weight = active_user.topic_count * PostTopicWeight + active_user.reply_count * PostReplyWeight
        active_user:save()
    end
end

return _M

