
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = {'revisionableMix', 'softDelete'}
}

local app, lf, tb, str = lx.kit()

function _M:new()

    self.guarded = {'id'}
    self.keepRevisionOf = {'deleted_at'}
end

-- For admin log

function _M:boot()

    self:__super(_M, 'boot')
    -- static.saving(function(model)
    --     Cache.forget('phphub_links')
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
    
    return cdn(file_name)
end

function _M.s__.allFromCache(expire)

    expire = expire or 1440
    
    return Cache.remember('phphub_links', expire, function()
        
        return static.where('is_enabled', 'yes'):get()
    end)
end

return _M

