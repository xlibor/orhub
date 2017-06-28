
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'messengerThread'
}

local app, lf, tb, str = lx.kit()

function _M:participant()

    return self:participants():where('user_id', '!=', Auth.id()):first().user
end

function _M.s__.participateBy(user_id)

    user_id = Auth.id()
    local thread_ids = tb.unique(Participant.byWhom(user_id):lists('thread_id'):toArray())
    
    return Thread.whereIn('id', thread_ids):orderBy('updated_at', 'desc'):paginate(15)
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

return _M

