
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    local users = User.lists('id'):toArray()
    local topics = Topic.lists('id'):toArray()
    local faker = app(Faker\Generator.class)
    local replies = factory(Reply.class):times(rand(300, 500)):make():each(function(reply)
        reply.user_id = faker:randomElement(users)
        reply.topic_id = faker:randomElement(topics)
    end)
    Reply.insert(replies:toArray())
end

return _M

