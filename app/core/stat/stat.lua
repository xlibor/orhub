
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

local cache_key = 'site_stat'
local cache_minutes = 10

function _M:getSiteStat()

    return Cache.remember(cache_key, cache_minutes, function()

        local entity = {}
        entity.topic_count = Topic.count()
        entity.reply_count = Reply.count()
        entity.user_count = User.count()
        
        return entity
    end)
end

return _M

