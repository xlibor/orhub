
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    _bond_ = 'creatorListener'
}

local app, lf, tb, str = lx.kit()

function _M:indexByTopicId(topic_id)

    local topic = Topic.find(topic_id)
    local replies = topic:getRepliesWithLimit(config('lxhub.repliesPerpage'))
    
    return self:response():paginator(replies, new('replyTransformer'))
end

function _M:indexByUserId(user_id)

    local user = User.findOrFail(user_id)
    local replies = Reply.whose(user.id):with('user'):recent():paginate(15)
    
    return self:response():paginator(replies, new('replyTransformer'))
end

function _M:store(request)

    if not Auth().user.verified then
        lx.throw(StoreResourceFailedException, '创建评论失败，请验证用户邮箱')
    end
    
    return app('lxhub\\Creators\\ReplyCreator'):create(self, request:except('_token'))
end

function _M:indexWebViewByTopic(topic_id)

    local topic = Topic.find(topic_id)
    local replies = topic:getRepliesWithLimit(config('lxhub.repliesPerpage'))
    
    return view('api.replies.index', compact('replies'))
end

function _M:indexWebViewByUser(user_id)

    local user = User.findOrFail(user_id)
    local replies = Reply.whose(user.id):recent():paginate(20)
    
    return view('api.users.users_replies_list', compact('replies'))
end

------------------------------------------
-- CreatorListener Delegate
------------------------------------------

function _M:creatorFailed(errors)

    lx.throw(StoreResourceFailedException, '创建评论失败：' .. output_msb(errors:getMessageBag()))
end

function _M:creatorSucceed(reply)

    return self:response():item(reply, new('replyTransformer'))
end

return _M

