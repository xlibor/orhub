
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'lxhub:calculate-active-user',
        description = 'Calculate active user'
    }
    
    return oo(this, mt)
end
const POST_TOPIC_WEIGHT = 4
const POST_REPLY_WEIGHT = 1
const PASS_DAYS = 7
function _M:ctor()

    parent.__construct()
end

function _M:handle()

    ActiveUser.query():delete()
    self:calculateTopicUsers()
    self:calculateReplyUsers()
    self:calculateWeight()
end

function _M.__:calculateTopicUsers()

    local data
    local topic_users = Topic.query():select(DB.raw('user_id, count(*) as topic_count')):where('created_at', '>=', Carbon.now():subDays(self.PASS_DAYS)):groupBy('user_id'):get()
    for _, value in pairs(topic_users) do
        data = {}
        data['user_id'] = value.user_id
        data['topic_count'] = value.topic_count
        ActiveUser.updateOrCreate({user_id = value.user_id}, data)
    end
end

function _M.__:calculateReplyUsers()

    local data
    local reply_users = Reply.query():select(DB.raw('user_id, count(*) as reply_count')):where('created_at', '>=', Carbon.now():subDays(self.PASS_DAYS)):groupBy('user_id'):get()
    for _, value in pairs(reply_users) do
        data = {}
        data['user_id'] = value.user_id
        data['reply_count'] = value.reply_count
        ActiveUser.updateOrCreate({user_id = value.user_id}, data)
    end
end

function _M.__:calculateWeight()

    local active_users = ActiveUser.all()
    for _, active_user in pairs(active_users) do
        active_user.weight = active_user.topic_count * self.POST_TOPIC_WEIGHT + active_user.reply_count * self.POST_REPLY_WEIGHT
        active_user:save()
    end
end

return _M

