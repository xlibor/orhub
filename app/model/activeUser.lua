
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.guarded = {'id'}
end

function _M:user()

    return self:belongsTo(User)
end

function _M:fetchAll()

    local data = Cache.remember('lxhub_active_users', 30, function()
        
        return self:with('user')
            :orderBy('weight', 'desc')
            :limit(8):get():col():pluck(function(item)
                return item('user')
            end)
    end)
    
    return data
end

return _M

