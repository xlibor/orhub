
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('blogs', function(table)
        table:increments('id')
        table:string('name'):index()
        table:string('slug'):index()
        table:text('description')
        table:string('cover')
        table:integer('user_id'):unsigned():default(0):index()
        table:integer('article_count'):unsigned():default(0)
        table:integer('subscriber_count'):unsigned():default(0)
        table:tinyInteger('is_recommended'):unsigned():default(0)
        table:tinyInteger('is_blocked'):unsigned():default(0)
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('blogs')
end

return _M

