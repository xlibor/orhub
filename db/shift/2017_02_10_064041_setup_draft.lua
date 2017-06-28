
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:table('users', function(table)
        table:integer('draft_count'):unsigned():default(0)
    end)
    schema:table('topics', function(table)
        table:enum('is_draft', {'yes', 'no'}):default('no'):index()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('users', function(table)
        table:dropColumn('draft_count')
    end)
    schema:table('topics', function(table)
        table:dropColumn('is_draft')
    end)
end

return _M

