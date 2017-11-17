
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.fillable = {'topic_id', 'content'}
end

function _M:topic()

    return self:belongsTo('.app.model.topic')
end

return _M

