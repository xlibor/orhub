
-- This is the create oauth scopes table migration class.



local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('oauth_scopes', function(table)
        table:string('id', 40):primary()
        table:string('description')
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('oauth_scopes')
end

return _M

