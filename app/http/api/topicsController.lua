
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    _bond_ = 'creatorListener'
}

local app, lf, tb, str = lx.kit()

function _M:index(request, topic)

    local filter = topic:correctApiFilter(request:get('filters'))
    local topics = topic:getTopicsWithFilter(filter, per_page())
    
    return self:response():paginator(topics, new('topicTransformer'))
end

function _M:indexByUserId(user_id)

    local topics = Topic.whose(user_id):withoutDraft():withoutBoardTopics():recent():paginate(15)
    
    return self:response():paginator(topics, new('topicTransformer'))
end

function _M:indexByUserVotes(user_id)

    local user = User.findOrFail(user_id)
    local topics = user:votedTopics():withoutDraft():withoutBoardTopics():orderBy('pivot_created_at', 'desc'):paginate(15)
    
    return self:response():paginator(topics, new('topicTransformer'))
end

function _M:store(request)

    if not Auth.user().verified then
        lx.throw(StoreResourceFailedException, '创建话题失败，请验证用户邮箱')
    end
    local data = tb.merge(request:except('_token'), {category_id = request.category_id})
    
    return app('Phphub\\Creators\\TopicCreator'):create(self, data)
end

function _M:show(id)

    local downvoted
    local upvoted
    local topic = Topic.with('user'):find(id)
    local topic_id = topic.id
    local user_id = Auth.id()
    if Auth.check() then
        upvoted = Vote.where({
            user_id = user_id,
            votable_id = topic_id,
            votable_type = 'App\\Models\\Topic',
            is = 'upvote'
        }):exists()
        downvoted = Vote.where({
            user_id = user_id,
            votable_id = topic_id,
            votable_type = 'App\\Models\\Topic',
            is = 'downvote'
        }):exists()
        topic.vote_up = upvoted
        topic.vote_down = downvoted
    end
    topic:increment('view_count', 1)
    
    return self:response():item(topic, new('topicTransformer'))
end

function _M:destroy(id)

    local topic = Topic.findOrFail(id)
    if Gate.denies('delete', topic) then
        lx.throw(AccessDeniedHttpException)
    end
    topic:delete()
    app(UserPublishedNewTopic.class):remove(Auth.user(), topic)
    app(BlogHasNewArticle.class):remove(Auth.user(), topic, topic:blogs():first())
    
    return {status = 'ok'}
end

function _M:voteUp(id)

    local topic = Topic.find(id)
    app('Phphub\\Vote\\Voter'):topicUpVote(topic)
    
    return response({['vote-up'] = true, vote_count = topic.vote_count})
end

function _M:voteDown(id)

    local topic = Topic.find(id)
    app('Phphub\\Vote\\Voter'):topicDownVote(topic)
    
    return response({['vote-down'] = true, vote_count = topic.vote_count})
end

function _M:showWebView(id)

    local topic = Topic.find(id)
    
    return view('api.topics.show', compact('topic'))
end

------------------------------------------
-- CreatorListener Delegate
------------------------------------------

function _M:creatorFailed(errors)

    lx.throw(StoreResourceFailedException, '创建话题失败：' .. output_msb(errors:getMessageBag()))
end

function _M:creatorSucceed(topic)

    return self:response():item(topic, new('topicTransformer'))
end

return _M

