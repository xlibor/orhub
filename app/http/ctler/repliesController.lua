
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    _bond_ = 'creatorListener'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self:middleware('auth')
end

function _M:store(request)

    return app('Phphub\\Creators\\ReplyCreator'):create(self, request:except('_token'))
end

function _M:vote(id)

    local reply = Reply.findOrFail(id)
    local type = app('Phphub\\Vote\\Voter'):replyUpVote(reply)
    
    return response({status = 200, message = lang('Operation succeeded.'), type = type['action_type']})
end

function _M:destroy(id)

    local reply = Reply.findOrFail(id)
    self:authorize('delete', reply)
    reply:delete()
    reply.topic:decrement('reply_count', 1)
    reply.topic:generateLastReplyUserInfo()
    app(UserRepliedTopic.class):remove(reply.user, reply)
    
    return response({status = 200, message = lang('Operation succeeded.')})
end

------------------------------------------
-- CreatorListener Delegate
------------------------------------------

function _M:creatorFailed(errors)

    if Request.ajax() then
        
        return response({status = 500, message = lang('Operation failed.')})
    else 
        Flash.error(lang('Operation failed.'))
        
        return Redirect.back()
    end
end

function _M:creatorSucceed(reply)

    reply.user.image_url = reply.user:present().gravatar
    if Request.ajax() then
        
        return response({
            status = 200,
            message = lang('Operation succeeded.'),
            reply = reply,
            manage_topics = reply.user:may('manage_topics') and 'yes' or 'no'
        })
    else 
        Flash.success(lang('Operation succeeded.'))
        
        return Redirect.to(reply.topic:link({'#last-reply'}))
    end
end

return _M

