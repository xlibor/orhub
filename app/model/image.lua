
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
            images[activity.indentifier] = self:__new():where('topic_id', str.replace(activity.indentifier, 't', '')):get()
        end
    end
    
    return images
end

return _M

