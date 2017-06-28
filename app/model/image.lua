
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        fillable = {'topic_id', 'link'}
    }
    
    return oo(this, mt)
end

function _M.s__.fromActivities(activities)

    local images = {}
    for _, activity in pairs(activities) do
        if str.strpos(activity.indentifier, 't') ~= false then
            images[activity.indentifier] = static.where('topic_id', str.replace(activity.indentifier, 't', '')):get()
        end
    end
    
    return images
end

return _M

