
-- This is the create oauth code scopes table migration class.



local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_auth_code_scopes', function(table)
        table:increments('id')
        table:string('auth_code_id', 40)
        table:string('scope_id', 40)
        table:timestamps()
        table:index('auth_code_id')
        table:index('scope_id')
        table:foreign('auth_code_id'):references('id'):on('oauth_auth_codes'):onDelete('cascade')
        table:foreign('scope_id'):references('id'):on('oauth_scopes'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_auth_code_scopes', function(table)
        table:dropForeign('oauth_auth_code_scopes_auth_code_id_foreign')
        table:dropForeign('oauth_auth_code_scopes_scope_id_foreign')
    end)
    schema:drop('oauth_auth_code_scopes')
end

return _M

