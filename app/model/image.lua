
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.fillable = {'topic_id', 'link'}
end

function _M:fromActivities(activities)

    local images = {}
    for _, activity in lf.each(activities) do
        if str.strpos(activity.indentifier, 't') then
            local imgList = self:__new():where('topic_id', '=', str.replace(activity.indentifier, 't', '')):get()
            if #imgList > 0 then
                local img = imgList[1]
                images[activity.indentifier] = imgList
            end
        end
    end
    
    return images
end

return _M

