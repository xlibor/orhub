
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseTransformer'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        availableIncludes = {'user', 'last_reply_user', 'replies', 'category'},
        defaultIncludes = {}
    }
    
    return oo(this, mt)
end

function _M:transformData(model)

    return {
        ['"id"'] = model.id,
        ['"category_id"'] = model.category_id,
        ['"title"'] = model.title,
        ['"body"'] = model.body,
        ['"reply_count"'] = model.reply_count,
        ['"vote_count"'] = model.vote_count,
        ['"vote_up"'] = model.vote_up,
        ['"vote_down"'] = model.vote_down,
        ['"updated_at"'] = model.updated_at,
        links = {details_web_view = route('topic.web_view', model.id), replies_web_view = route('replies.web_view', model.id), web_url = str.trim(config('app.url'), '/') .. '/topics/' .. model.id}
    }
end

function _M:includeUser(model)

    return self:item(model.user, new('userTransformer'))
end

function _M:includeLastReplyUser(model)

    return self:item(model.lastReplyUser or model.user, new('userTransformer'))
end

function _M:includeReplies(model)

    return self:collection(model.replies, new('replyTransformer'))
end

function _M:includeCategory(model)

    return self:item(model.category, new('categoryTransformer'))
end

return _M

