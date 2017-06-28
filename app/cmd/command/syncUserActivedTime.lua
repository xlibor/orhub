
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'phphub:sync-user-actived-time',
        description = 'Sync user actived time'
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    local data = Cache.pull(config('phphub.actived_time_for_update'))
    if not data then
        self:error('Error: No Data!')
        
        return false
    end
    for user_id, last_actived_at in pairs(data) do
        User.query():where('id', user_id):update({last_actived_at = last_actived_at})
    end
    self:info('Done!')
end

return _M

