
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create(Models.table('threads'), function(table)
        table:increments('id')
        table:string('subject')
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop(Models.table('threads'))
end

return _M

