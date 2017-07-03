
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:table('participants', function(table)
        table:softDeletes()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('participants', function(table)
        table:dropSoftDeletes()
    end)
end

return _M

