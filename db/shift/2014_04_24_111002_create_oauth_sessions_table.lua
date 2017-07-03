
-- This is the create oauth sessions table migration class.



local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_sessions', function(table)
        table:increments('id')
        table:string('client_id', 40)
        table:enum('owner_type', {'client', 'user'}):default('user')
        table:string('owner_id')
        table:string('client_redirect_uri'):nullable()
        table:timestamps()
        table:index({'client_id', 'owner_type', 'owner_id'})
        table:foreign('client_id'):references('id'):on('oauth_clients'):onDelete('cascade'):onUpdate('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:table('oauth_sessions', function(table)
        table:dropForeign('oauth_sessions_client_id_foreign')
    end)
    schema:drop('oauth_sessions')
end

return _M

