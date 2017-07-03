
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

function _M:up(schema)

    schema:create('blog_authors', function(table)
        table:integer('user_id'):unsigned():index()
        table:integer('blog_id'):unsigned():index()
        table:foreign('user_id'):references('id'):on('users'):onUpdate('cascade'):onDelete('cascade')
        table:foreign('blog_id'):references('id'):on('blogs'):onUpdate('cascade'):onDelete('cascade')
    end)
end

function _M:down(schema)

    schema:drop('blog_authors')
end

return _M

