
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('attentions', function(table)
        table:increments('id')
        table:integer('topic_id'):unsigned():default(0):index()
        table:integer('user_id'):unsigned():default(0):index()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('attentions')
end

return _M

