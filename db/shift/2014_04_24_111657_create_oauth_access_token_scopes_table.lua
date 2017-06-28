
-- This is the create oauth access token scopes table migration class.



local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_access_token_scopes', function(table)
        table:increments('id')
        table:string('access_token_id', 40)
        table:string('scope_id', 40)
        table:timestamps()
        table:index('access_token_id')
        table:index('scope_id')
        table:foreign('access_token_id'):references('id'):on('oauth_access_tokens'):onDelete('cascade')
        table:foreign('scope_id'):references('id'):on('oauth_scopes'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_access_token_scopes', function(table)
        table:dropForeign('oauth_access_token_scopes_scope_id_foreign')
        table:dropForeign('oauth_access_token_scopes_access_token_id_foreign')
    end)
    schema:drop('oauth_access_token_scopes')
end

return _M

