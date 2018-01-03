
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.guarded = {'id'}
end

function _M:topic()

    return self:belongsTo(Topic)
end

function _M:fetchAll()

    local data = Cache.remember('orhub_hot_topics', 30, function()
        
        return self:orderBy('weight', 'desc')
            :with('topic', 'topic.user')
            :limit(10):get():col():pluck(function(item)
                return item('topic')
            end)
    end)
    
    return data
end

return _M

