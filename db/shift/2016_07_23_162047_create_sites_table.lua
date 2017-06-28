
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('sites', function(table)
        table:increments('id')
        table:string('title'):index()
        table:string('description'):nullable()
        table:string('type'):index():default('site')
        table:string('link'):index()
        table:string('favicon'):nullable()
        table:integer('order'):default(0)
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('sites')
end

return _M

