
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.guarded = {'id'}
end

function _M:topic()

    return self:belongsTo(Topic.class)
end

function _M.s__.fetchAll()

    local data = Cache.remember('phphub_hot_topics', 30, function()
        
        return static.orderBy('weight', 'DESC'):with('topic', 'topic.user'):limit(10):get():pluck('topic')
    end)
    
    return data
end

return _M

