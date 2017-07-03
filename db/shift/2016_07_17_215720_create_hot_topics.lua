
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('hot_topics', function(table)
        table:increments('id')
        table:integer('topic_id'):default(0):index()
        table:integer('vote_count'):default(0)
        table:integer('reply_count'):default(0)
        table:integer('weight'):default(0):index()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('hot_topics')
end

return _M

