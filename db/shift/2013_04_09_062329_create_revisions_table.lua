
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('revisions', function(table)
        table:increments('id')
        table:string('revisionable_type')
        table:integer('revisionable_id')
        table:integer('user_id'):nullable()
        table:string('key')
        table:text('old_value'):nullable()
        table:text('new_value'):nullable()
        table:timestamps()
        table:index({'revisionable_id', 'revisionable_type'})
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('revisions')
end

return _M

