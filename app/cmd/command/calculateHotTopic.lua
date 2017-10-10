
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.description = 'calculate hot topic'
end

local VoteTopicWeight = 5
local ReplyTopicWeight = 3
local PassDays = 7

function _M:run()

    HotTopic.query():delete()
    self:calculateTopics()
    self:info(self.description)
end

function _M:calculateTopics()

    local data
    local topics = Topic.where(
            'created_at', '>=', Dt.now():subDays(PassDays)
        ):get()

    for _, topic in ipairs(topics) do
        data = {}
        data.topic_id = topic.id
        data.reply_count = Reply.where('topic_id', topic.id):count()
        data.vote_count = Vote.where('votable_type', '.app.model.topic')
            :where('votable_id', topic.id)
            :where('is', 'upvote'):count()
        data.weight = data.vote_count * VoteTopicWeight + data.reply_count * ReplyTopicWeight
        HotTopic.updateOrCreate({topic_id = topic.id}, data)
    end
end

return _M

