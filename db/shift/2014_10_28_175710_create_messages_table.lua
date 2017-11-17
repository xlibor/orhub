
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('messages', function(table)
        table:increments('id')
        table:integer('thread_id'):unsigned()
        table:integer('user_id'):unsigned()
        table:text('body')
        table:softDeletes()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('messages')
end

return _M

