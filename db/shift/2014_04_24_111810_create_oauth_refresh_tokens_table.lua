
-- This is the create oauth refresh tokens table migration class.



local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_refresh_tokens', function(table)
        table:string('id', 40):unique()
        table:string('access_token_id', 40):primary()
        table:integer('expire_time')
        table:timestamps()
        table:foreign('access_token_id'):references('id'):on('oauth_access_tokens'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_refresh_tokens', function(table)
        table:dropForeign('oauth_refresh_tokens_access_token_id_foreign')
    end)
    schema:drop('oauth_refresh_tokens')
end

return _M

