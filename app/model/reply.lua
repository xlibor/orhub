
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = 'revisionableTrait, SoftDeletes'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        keepRevisionOf = {'deleted_at'},
        fillable = {'body', 'source', 'user_id', 'topic_id', 'body_original'}
    }
    
    return oo(this, mt)
end

-- For admin log
function _M.s__.boot()

    parent.boot()
    static.created(function(topic)
        SiteStatus.newReply()
    end)
end

function _M:votes()

    return self:morphMany(Vote.class, 'votable')
end

function _M:user()

    return self:belongsTo(User.class)
end

function _M:topic()

    return self:belongsTo(Topic.class):withoutBoardTopics()
end

function _M:scopeWhose(query, user_id)

    return query:where('user_id', '=', user_id):with('topic')
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

return _M

