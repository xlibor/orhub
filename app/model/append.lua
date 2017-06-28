
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        fillable = {'topic_id', 'content'}
    }
    
    return oo(this, mt)
end

function _M:topic()

    return self:belongsTo('Topic')
end

return _M

