
-- This is the create oauth session scopes table migration class.



local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_session_scopes', function(table)
        table:increments('id')
        table:integer('session_id'):unsigned()
        table:string('scope_id', 40)
        table:timestamps()
        table:index('session_id')
        table:index('scope_id')
        table:foreign('session_id'):references('id'):on('oauth_sessions'):onDelete('cascade')
        table:foreign('scope_id'):references('id'):on('oauth_scopes'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_session_scopes', function(table)
        table:dropForeign('oauth_session_scopes_session_id_foreign')
        table:dropForeign('oauth_session_scopes_scope_id_foreign')
    end)
    schema:drop('oauth_session_scopes')
end

return _M

