
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('topics', function(table)
        table:increments('id')
        table:string('title'):index()
        table:string('source'):nullable():index()
        -- 来源关注：iOS，Android
        table:text('body')
        table:integer('user_id'):unsigned():default(0):index()
        table:integer('category_id'):unsigned():default(0):index()
        table:integer('reply_count'):default(0):index()
        table:integer('view_count'):unsigned():default(0):index()
        table:integer('vote_count'):default(0):index()
        table:integer('last_reply_user_id'):unsigned():default(0):index()
        table:integer('order'):default(0):index()
        table:enum('is_excellent', {'yes', 'no'}):default('no'):index()
        table:enum('is_blocked', {'yes', 'no'}):default('no'):index()
        table:text('body_original'):nullable()
        table:text('excerpt'):nullable()
        table:enum('is_tagged', {'yes', 'no'}):default('no'):index()
        table:text('summary'):nullable()
        table:string('extra'):nullable()
        table:softDeletes()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('topics')
end

return _M

