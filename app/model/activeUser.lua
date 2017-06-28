
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.guarded = {'id'}
end

function _M:user()

    return self:belongsTo(User.class)
end

function _M.s__.fetchAll()

    local data = Cache.remember('phphub_active_users', 30, function()
        
        return static.with('user'):orderBy('weight', 'DESC'):limit(8):get():pluck('user')
    end)
    
    return data
end

return _M

