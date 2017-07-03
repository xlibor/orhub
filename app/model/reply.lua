
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = {
        -- 'revisionableMix',
        'softDelete'
    }
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.keepRevisionOf = {'deleted_at'}
    self.fillable = {'body', 'source', 'user_id', 'topic_id', 'body_original'}
end

-- For admin log
function _M:boot()

    self:__super(_M, 'boot')
    -- static.created(function(topic)
    --     SiteStatus.newReply()
    -- end)
end

function _M:votes()

    return self:morphMany(Vote, 'votable')
end

function _M:user()

    return self:belongsTo(User)
end

function _M:topic()

    return self:belongsTo(Topic):withoutBoardTopics()
end

function _M:scopeWhose(query, user_id)

    return query:where('user_id', '=', user_id):with('topic')
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

return _M

