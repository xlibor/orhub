
-- This is the create oauth client scopes table migration class.



local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_client_scopes', function(table)
        table:increments('id')
        table:string('client_id', 40)
        table:string('scope_id', 40)
        table:timestamps()
        table:index('client_id')
        table:index('scope_id')
        table:foreign('client_id'):references('id'):on('oauth_clients'):onDelete('cascade')
        table:foreign('scope_id'):references('id'):on('oauth_scopes'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_client_scopes', function(table)
        table:dropForeign('oauth_client_scopes_client_id_foreign')
        table:dropForeign('oauth_client_scopes_scope_id_foreign')
    end)
    schema:drop('oauth_client_scopes')
end

return _M

