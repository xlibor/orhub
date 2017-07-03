
-- This is the create oauth grant scopes table migration class.



local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_grant_scopes', function(table)
        table:increments('id')
        table:string('grant_id', 40)
        table:string('scope_id', 40)
        table:timestamps()
        table:index('grant_id')
        table:index('scope_id')
        table:foreign('grant_id'):references('id'):on('oauth_grants'):onDelete('cascade')
        table:foreign('scope_id'):references('id'):on('oauth_scopes'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_grant_scopes', function(table)
        table:dropForeign('oauth_grant_scopes_grant_id_foreign')
        table:dropForeign('oauth_grant_scopes_scope_id_foreign')
    end)
    schema:drop('oauth_grant_scopes')
end

return _M

