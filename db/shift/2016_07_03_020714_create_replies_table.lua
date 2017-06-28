
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('replies', function(table)
        table:increments('id')
        table:string('source'):nullable():index()
        -- 来源关注：iOS，Android
        table:integer('topic_id'):unsigned():default(0):index()
        table:integer('user_id'):unsigned():default(0):index()
        table:enum('is_blocked', {'yes', 'no'}):default('no'):index()
        table:integer('vote_count'):default(0):index()
        table:text('body')
        table:text('body_original'):nullable()
        table:softDeletes()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('replies')
end

return _M

