
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:table('topics', function(table)
        table:string('slug'):index():nullable()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('topics', function(table)
        table:dropColumn('slug')
    end)
end

return _M

