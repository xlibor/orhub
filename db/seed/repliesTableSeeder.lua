
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()
local fair = lx.h.fair
local rand = lf.rand

function _M:run()

    local users = User.pluck('id')
    local topics = Topic.pluck('id')
    local faker = app('lxlib.db.orm.seed.faker')

    local replies = fair(Reply):times(rand(300, 500)):make():each(function(reply)
        reply.user_id = faker:randomElement(users)
        reply.topic_id = faker:randomElement(topics)
    end)
    Reply.inserts(replies:toArr())
end

return _M

