
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('active_users', function(table)
        table:increments('id')
        table:integer('user_id'):default(0):index()
        table:integer('topic_count'):default(0)
        table:integer('reply_count'):default(0)
        table:integer('weight'):default(0):index()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('active_users')
end

return _M

