
-- This is the create oauth client table migration class.



local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_clients', function(table)
        table:string('id', 40):primary()
        table:string('secret', 40)
        table:string('name')
        table:unsignedInteger('user_id'):index()
        table:timestamps()
        table:unique({'id', 'secret'})
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('oauth_clients')
end

return _M

