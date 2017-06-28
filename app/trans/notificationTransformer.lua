
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseTransformer'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        availableIncludes = {'from_user', 'topic', 'reply'}
    }
    
    return oo(this, mt)
end

function _M:transformData(model)

    return {
        ['"id"'] = model.id,
        ['"type_msg"'] = model:present().lableUp,
        ['"message"'] = model:present():message(),
        ['"created_at"'] = model.created_at:toDateTimeString()
    }
end

function _M:includeFromUser(model)

    return self:item(model.fromUser, new('userTransformer'))
end

function _M:includeReply(model)

    if model.reply == nil then
        
        return
    end
    
    return self:item(model.reply, new('replyTransformer'))
end

function _M:includeTopic(model)

    if model.topic == nil then
        
        return
    end
    
    return self:item(model.topic, new('topicTransformer'))
end

return _M

