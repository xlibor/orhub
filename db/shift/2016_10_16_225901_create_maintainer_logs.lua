
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

function _M:up(schema)

    schema:create('maintainer_logs', function(table)
        table:increments('id')
        table:timestamp('start_time')
        table:timestamp('end_time')
        table:integer('user_id'):unsigned():index()
        table:integer('topics_count'):unsigned()
        table:integer('replies_count'):unsigned()
        table:integer('excellent_count'):unsigned()
        table:integer('sink_count'):unsigned()
        table:timestamps()
    end)
end

function _M:down(schema)

    schema:drop('maintainer_logs')
end

return _M

