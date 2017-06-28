
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('links', function(table)
        table:increments('id')
        table:string('title'):index()
        table:string('link'):index()
        table:text('cover'):nullable()
        table:enum('is_enabled', {'yes', 'no'}):default('yes'):index()
        table:softDeletes()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('links')
end

return _M

