
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    local users = User.lists('id'):toArray()
    local categories = Category.where('id', '!=', 8):lists('id'):toArray()
    local faker = app(Faker\Generator.class)
    local topics = factory(Topic.class):times(rand(100, 200)):make():each(function(topic)
        topic.user_id = faker:randomElement(users)
        topic.category_id = faker:randomElement(categories)
        topic.is_excellent = rand(0, 1) and 'yes' or 'no'
    end)
    Topic.insert(topics:toArray())
    -- Test User Topic Seeding
    local admin_topics = factory(Topic.class):times(rand(1, 100)):make():each(function(topic)
        topic.user_id = 1
        topic.category_id = faker:randomElement(categories)
    end)
    Topic.insert(admin_topics:toArray())
    -- Test User Article Seeding
    local admin_articles = factory(Topic.class):times(31):make():each(function(topic)
        topic.user_id = faker:randomElement({1, 2})
        topic.category_id = 8
    end)
    Topic.insert(admin_articles:toArray())
    -- Building connections
    Artisan.call('topics:blog_topics')
end

return _M

