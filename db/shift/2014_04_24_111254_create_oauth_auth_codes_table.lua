
-- This is the create oauth auth codes table migration class.



local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_auth_codes', function(table)
        table:string('id', 40):primary()
        table:integer('session_id'):unsigned()
        table:string('redirect_uri')
        table:integer('expire_time')
        table:timestamps()
        table:index('session_id')
        table:foreign('session_id'):references('id'):on('oauth_sessions'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_auth_codes', function(table)
        table:dropForeign('oauth_auth_codes_session_id_foreign')
    end)
    schema:drop('oauth_auth_codes')
end

return _M

