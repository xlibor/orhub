
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('appends', function(table)
        table:increments('id')
        table:text('content')
        table:integer('topic_id'):unsigned():default(0):index()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('appends')
end

return _M

