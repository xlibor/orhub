
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'model',
    _mix_       = 'presentableMix',
    _static_    = {}
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.presenter = '.app.core.presenter.site'
    self.guarded = {'id'}
end

function _M:boot()

    self:__super(_M, 'boot')
    -- static.saving(function(model)
    --     Cache.forget('lxhub_sites')
    -- end)
end

function _M.s__.allFromCache(expire)

    expire = expire or 1440
    local data = Cache.remember('lxhub_sites', 60, function()
        local raw_sites = Site:orderBy('order', 'desc'):orderBy('created_at', 'desc'):get()
        local sorted = {}
        sorted.site = raw_sites:filter(function(item)
            
            return item.type == 'site'
        end)
        sorted.blog = raw_sites:filter(function(item)
            
            return item.type == 'blog'
        end)
        sorted.weibo = raw_sites:filter(function(item)
            
            return item.type == 'weibo'
        end)
        sorted.dev_service = raw_sites:filter(function(item)
            
            return item.type == 'dev_service'
        end)
        sorted.site_foreign = raw_sites:filter(function(item)
            
            return item.type == 'site_foreign'
        end)
        
        return sorted
    end)
    
    return data
end

return _M

