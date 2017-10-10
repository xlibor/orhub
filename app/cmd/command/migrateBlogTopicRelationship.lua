
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.description = 'migrate blog-topic relationship'
end

function _M:run()

    local topics = Topic.where('category_id', app:conf('lxhub.blogCategoryId'))
        :get()

    for _, topic in ipairs(topics) do
        blog = topic('user'):blogs():first()
        if not blog:topics():where('topic_id', topic.id):exists() then
            blog:topics():attach(topic.id)
            if not blog:authors():where('user_id', topic.user_id):exists() then
                blog:authors():attach(topic.user_id)
            end
        end
    end

    self:info(self.description)
end

return _M

