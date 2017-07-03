
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:table('users', function(table)
        table:integer('article_count'):unsigned():default(0)
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('users', function(table)
        table:dropColumn('article_count')
    end)
end

return _M

