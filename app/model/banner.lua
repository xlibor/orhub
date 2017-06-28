
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = 'revisionableTrait, SoftDeletes'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        keepRevisionOf = {'deleted_at'}
    }
    
    return oo(this, mt)
end

-- For admin log

function _M.s__.boot()

    parent.boot()
    static.saving(function(article)
        Cache.forget('phphub_banner')
    end)
end

function _M:setImageUrlAttribute(file_name)

    local parser_url
    if str.startWith(file_name, 'http') then
        parser_url = str.split(file_name, '/')
        file_name = end(parser_url)
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
        return = {}
        data = Banner.orderBy('position', 'DESC'):orderBy('order', 'ASC'):get()
        for _, banner in pairs(data) do
            tapd(return[banner.position], banner)
        end
        
        return return
    end)
    
    return data
end

return _M

