
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    _bond_ = 'creatorListener'
}

local app, lf, tb, str, new = lx.kit()
local lang = Ah.lang
local response = lx.h.response

function _M:ctor()

    self:setBar('auth')
end

function _M:store(c)

    local req = c:form('storeReplyRequest')
    
    return new('.app.http.doer.reply'):create(self, req:except('_token'))
end

function _M:vote(c, id)

    local reply = Reply.findOrFail(id)
    local voteInfo = app('.app.core.vote.voter'):replyUpVote(reply)
    
    return c:json({
        status = 200, message = lang('Operation succeeded.'),
        type = voteInfo.action_type
    })
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

    if Req.ajax then
        
        return response({status = 500, message = lang('Operation failed.')})
    else 
        Flash.error(lang('Operation failed.'))
        
        return Redirect.back()
    end
end

function _M:creatorSucceed(reply)

    reply('user').image_url = reply('user'):present('gravatar')
    if Req.ajax then
        
        return {
            status = 200,
            message = lang('Operation succeeded.'),
            reply = reply:toArr(),
            manage_topics = reply('user'):can('manage_topics') and 'yes' or 'no'
        }
    else
        Flash.success(lang('Operation succeeded.'))
        
        return Redirect.to(reply.topic:link({'#last-reply'}))
    end
end

return _M

