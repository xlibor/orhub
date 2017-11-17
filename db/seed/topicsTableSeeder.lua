
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()
local fair = lx.h.fair
local rand = lf.rand

function _M:run()

    local users = User.pluck('id')
    local categories = Category.where('id', '!=', 8):pluck('id')
    local faker = app('lxlib.db.orm.seed.faker')
    
    local topics = fair(Topic):times(rand(100, 200)):make():each(function(topic)
        topic.user_id = faker:randomElement(users)
        topic.category_id = faker:randomElement(categories)
        topic.is_excellent = rand(0, 1) and 'yes' or 'no'
    end)
    Topic.inserts(topics:toArr())

    -- Test User Topic Seeding
    local admin_topics = fair(Topic):times(rand(1, 100)):make():each(function(topic)
        topic.user_id = 1
        topic.category_id = faker:randomElement(categories)
    end)
    Topic.inserts(admin_topics:toArr())

    -- Test User Article Seeding
    local admin_articles = fair(Topic):times(31):make():each(function(topic)
        topic.user_id = faker:randomElement({1, 2})
        topic.category_id = 8
    end)
    Topic.inserts(admin_articles:toArr())
    
    -- Building connections
    app:run('topics:blog_topics')
end

return _M

