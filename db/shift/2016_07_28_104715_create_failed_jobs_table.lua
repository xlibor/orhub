
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('failed_jobs', function(table)
        table:increments('id')
        table:text('connection')
        table:text('queue')
        table:longText('payload')
        table:timestamp('failed_at'):useCurrent()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('failed_jobs')
end

return _M

