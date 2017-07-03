
-- This is the create oauth access tokens table migration class.



local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_access_tokens', function(table)
        table:string('id', 40):primary()
        table:integer('session_id'):unsigned()
        table:integer('expire_time')
        table:timestamps()
        table:unique({'id', 'session_id'})
        table:index('session_id')
        table:foreign('session_id'):references('id'):on('oauth_sessions'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_access_tokens', function(table)
        table:dropForeign('oauth_access_tokens_session_id_foreign')
    end)
    schema:drop('oauth_access_tokens')
end

return _M

