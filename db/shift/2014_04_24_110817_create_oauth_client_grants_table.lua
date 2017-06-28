
-- This is the create oauth client grants table migration class.



local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_client_grants', function(table)
        table:increments('id')
        table:string('client_id', 40)
        table:string('grant_id', 40)
        table:timestamps()
        table:index('client_id')
        table:index('grant_id')
        table:foreign('client_id'):references('id'):on('oauth_clients'):onDelete('cascade'):onUpdate('no action')
        table:foreign('grant_id'):references('id'):on('oauth_grants'):onDelete('cascade'):onUpdate('no action')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_client_grants', function(table)
        table:dropForeign('oauth_client_grants_client_id_foreign')
        table:dropForeign('oauth_client_grants_grant_id_foreign')
    end)
    schema:drop('oauth_client_grants')
end

return _M

