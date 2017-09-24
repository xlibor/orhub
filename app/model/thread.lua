
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'messenger.thread'
}

local app, lf, tb, str = lx.kit()

function _M:participant()

    local participant = self:participants()
        :where('user_id', '!=', Auth.id())
        :first()

    return participant('user')
end

function _M:participateBy(user_id)

    user_id = user_id or Auth.id()

    local thread_ids = tb.unique(Participant.byWhom(user_id):pluck('thread_id'))

    return Thread.whereIn('id', thread_ids):orderBy('updated_at', 'desc'):paginate(15)
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

return _M

