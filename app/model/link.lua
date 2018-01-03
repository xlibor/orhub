
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = {
        -- 'revisionableMix',
        'softDelete'
    }
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.guarded = {'id'}
    self.keepRevisionOf = {'deleted_at'}
end

-- For admin log

function _M:boot()

    self:__super(_M, 'boot')
    -- static.saving(function(model)
    --     Cache.forget('orhub_links')
    -- end)
end

function _M:setCoverAttribute(file_name)

    local parser_url
    if str.startWith(file_name, 'http') then
        parser_url = str.split(file_name, '/')
        file_name = tb.last(parser_url)
    end
    self.attributes['cover'] = 'uploads/banners/' .. file_name
end

function _M:getCoverAttribute(file_name)

    if str.startWith(file_name, 'http') then
        
        return file_name
    end
    
    return Ah.cdn(file_name)
end

function _M:allFromCache(expire)

    expire = expire or 1440
    
    return Cache.remember('orhub_links', expire, function()
        
        return self:where('is_enabled', 'yes'):get()
    end)
end

return _M

