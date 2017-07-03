
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:table('users', function(table)
        table:string('password', 60):nullable()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('users', function(table)
        table:dropColumn('password')
    end)
end

return _M

