
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

const CACHE_KEY = 'site_stat'
const CACHE_MINUTES = 10
function _M:getSiteStat()

    return Cache.remember(self.CACHE_KEY, self.CACHE_MINUTES, function()
        entity = new('statEntity')
        entity.topic_count = Topic.count()
        entity.reply_count = Reply.count()
        entity.user_count = User.count()
        
        return entity
    end)
end

return _M

