
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:me()

    return self:show(Auth.id())
end

function _M:show(id)

    local user = User.find(id)
    user.links = true
    -- 在 Transformer 中返回 links，我的评论 web view
    
    return self:response():item(user, new('userTransformer'))
end

function _M:update(id, request)

    local user = User.findOrFail(id)
    if Gate.denies('update', user) then
        lx.throw(AccessDeniedHttpException)
    end
    try(function()
        user = request:performUpdate(user)
        
        return self:response():item(user, new('userTransformer'))
    end)
    :catch(function(ValidatorException e) 
        lx.throw(UpdateResourceFailedException, '无法更新用户信息：' .. output_msb(e:getMessageBag()))
    end)
    :run()
end

return _M

