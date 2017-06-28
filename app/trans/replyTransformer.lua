
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseTransformer'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        availableIncludes = {'user'}
    }
    
    return oo(this, mt)
end

function _M:transformData(model)

    return {
        ['"id"'] = model.id,
        ['"topic_id"'] = model.topic_id,
        ['"user_id"'] = model.user_id,
        ['"body"'] = model.body,
        created_at = model.created_at:toDateTimeString(),
        updated_at = model.updated_at:toDateTimeString()
    }
end

function _M:includeUser(model)

    return self:item(model.user, new('userTransformer'))
end

return _M

