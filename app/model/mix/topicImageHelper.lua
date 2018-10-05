
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:cover()

    return self:images():first()
end

function _M:images()

    return self:hasMany(Image)
end

function _M:collectImages()

    local data
    local link
    -- For update topic logic
    self:images():delete()
    local links = Ah.get_image_links(self.body)
    
    if #links > 0 then
        link = tb.shift(links)
        data = {topic_id = self.id, link = link}
        Image.updateOrCreate(data, data)
    end
end

return _M

