
-- This is the create oauth client endpoints table migration class.



local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_client_endpoints', function(table)
        table:increments('id')
        table:string('client_id', 40)
        table:string('redirect_uri')
        table:timestamps()
        table:unique({'client_id', 'redirect_uri'})
        table:foreign('client_id'):references('id'):on('oauth_clients'):onDelete('cascade'):onUpdate('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_client_endpoints', function(table)
        table:dropForeign('oauth_client_endpoints_client_id_foreign')
    end)
    schema:drop('oauth_client_endpoints')
end

return _M

