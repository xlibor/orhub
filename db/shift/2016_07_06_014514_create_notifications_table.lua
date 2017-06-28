
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('notifications', function(table)
        table:increments('id')
        table:integer('from_user_id'):index()
        table:integer('user_id'):index()
        table:integer('topic_id'):index()
        table:integer('reply_id'):nullable():index()
        table:text('body'):nullable()
        table:string('type'):index()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('notifications')
end

return _M

