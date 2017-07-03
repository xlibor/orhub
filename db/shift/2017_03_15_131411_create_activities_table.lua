
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('activities', function(table)
        table:increments('id')
        table:string('causer'):index()
        table:string('type'):index()
        table:string('indentifier'):index()
        table:integer('user_id'):unsigned():index()
        table:text('data'):nullable()
        table:timestamps()
        table:foreign('user_id'):references('id'):on('users'):onUpdate('cascade'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('activities')
end

return _M

