
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'topics:blog_topics',
        description = '建立文章博客多对多连接！'
    }
    
    return oo(this, mt)
end

-- The name and signature of the console command.
-- @var string
-- The console command description.
-- @var string
-- Create a new command instance.


function _M:ctor()

    parent.__construct()
end

function _M:handle()

    Topic.where('category_id', config('phphub.blog_category_id')):chunk(200, function(topics)
        for _, topic in pairs(topics) do
            blog = topic.user:blogs():first()
            if not blog:topics():where('topic_id', topic.id):exists() then
                blog:topics():attach(topic.id)
                if not blog:authors():where('user_id', topic.user_id):exists() then
                    blog:authors():attach(topic.user_id)
                end
            end
            self:info("处理完成：{topic.id}")
        end
    end)
end

return _M

