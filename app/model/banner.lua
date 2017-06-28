
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = {'revisionableMix', 'softDelete'}
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.keepRevisionOf = {'deleted_at'}
end

-- For admin log

function _M:boot()

    self:__super(_M, 'boot')
    -- static.saving(function(article)
    --     Cache.forget('phphub_banner')
    -- end)
end

function _M:setImageUrlAttribute(file_name)

    local parser_url
    if str.startWith(file_name, 'http') then
        parser_url = str.split(file_name, '/')
        file_name = tb.last(parser_url)
    end
    self.attributes['image_url'] = 'uploads/banners/' .. file_name
end

function _M:getImageUrlAttribute(file_name)

    if str.startWith(file_name, 'http') then
        
        return file_name
    end
    
    return cdn(file_name)
end

function _M.s__.allByPosition()

    local data = Cache.remember('phphub_banner', 60, function()
        local ret = {}
        local data = Banner.orderBy('position', 'DESC'):orderBy('order', 'ASC'):get()
        for _, banner in pairs(data) do
            tapd(ret[banner.position], banner)
        end
        
        return ret
    end)
    
    return data
end

return _M

