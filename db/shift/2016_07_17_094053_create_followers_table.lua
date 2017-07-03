
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('followers', function(table)
        table:increments('id')
        table:unsignedInteger('user_id')
        table:unsignedInteger('follow_id')
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('followers')
end

return _M

