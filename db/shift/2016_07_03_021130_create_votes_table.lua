
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('votes', function(table)
        table:increments('id')
        table:integer('user_id'):unsigned():default(0)
        table:integer('votable_id'):unsigned():default(0)
        table:string('votable_type'):index()
        table:string('is'):index()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('votes')
end

return _M

