
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'phphub:calculate-hot-topic',
        description = 'Calculate hot topic'
    }
    
    return oo(this, mt)
end
const VOTE_TOPIC_WEIGHT = 5
const REPLY_TOPIC_WEIGHT = 3
const PASS_DAYS = 7
function _M:ctor()

    parent.__construct()
end

function _M:handle()

    HotTopic.query():delete()
    self:calculateTopics()
end

function _M:calculateTopics()

    local data
    local topics = Topic.where('created_at', '>=', Carbon.now():subDays(self.PASS_DAYS)):get()
    for _, topic in pairs(topics) do
        data = {}
        data['topic_id'] = topic.id
        data['reply_count'] = Reply.where('topic_id', topic.id):count()
        data['vote_count'] = Vote.where('votable_type', 'App\\Models\\Topic'):where('votable_id', topic.id):where('is', 'upvote'):count()
        data['weight'] = data['vote_count'] * self.VOTE_TOPIC_WEIGHT + data['reply_count'] * self.REPLY_TOPIC_WEIGHT
        HotTopic.updateOrCreate({topic_id = topic.id}, data)
    end
end

return _M

