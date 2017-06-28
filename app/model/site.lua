
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = 'presentableTrait'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        presenter = SitePresenter.class,
        guarded = {'id'}
    }
    
    return oo(this, mt)
end

function _M.s__.boot()

    parent.boot()
    static.saving(function(model)
        Cache.forget('phphub_sites')
    end)
end

function _M.s__.allFromCache(expire)

    expire = expire or 1440
    local data = Cache.remember('phphub_sites', 60, function()
        raw_sites = static.orderBy('order', 'desc'):orderBy('created_at', 'desc'):get()
        sorted = {}
        sorted['site'] = raw_sites:filter(function(item)
            
            return item.type == 'site'
        end)
        sorted['blog'] = raw_sites:filter(function(item)
            
            return item.type == 'blog'
        end)
        sorted['weibo'] = raw_sites:filter(function(item)
            
            return item.type == 'weibo'
        end)
        sorted['dev_service'] = raw_sites:filter(function(item)
            
            return item.type == 'dev_service'
        end)
        sorted['site_foreign'] = raw_sites:filter(function(item)
            
            return item.type == 'site_foreign'
        end)
        
        return sorted
    end)
    
    return data
end

return _M

