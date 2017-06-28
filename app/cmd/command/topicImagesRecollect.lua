
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'topics:images_recollect',
        description = '把所有话题里的图片提取出来。'
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    Topic.chunk(200, function(topics)
        for _, topic in pairs(topics) do
            topic:collectImages()
            self:info("处理完成：{topic.id}")
        end
    end)
end

return _M

