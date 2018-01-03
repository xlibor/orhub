
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'model',
    _mix_       = {
        -- 'revisionableMix',
        'softDelete'
    },
    _static_    = {}
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.keepRevisionOf = {'deleted_at'}
end

-- For admin log

function _M:boot()

    self:__super(_M, 'boot')
    -- static.saving(function(article)
    --     Cache.forget('orhub_banner')
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
    
    return Ah.cdn(file_name)
end

function _M.s__.allByPosition()

    local data = Cache.remember('orhub_banner', 60, function()
        local ret = {}
        local data = Banner.orderBy({'position', 'desc'}, {'order', 'ASC'}):get()

        for _, banner in ipairs(data) do
            tb.mapd(ret, banner.position, banner)
        end
        
        return ret
    end)
    
    return data
end

return _M

