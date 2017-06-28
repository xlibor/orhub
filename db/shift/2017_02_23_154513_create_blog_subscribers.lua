
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('blog_subscribers', function(table)
        table:increments('id')
        table:integer('user_id'):unsigned():index()
        table:integer('blog_id'):unsigned():index()
        table:foreign('user_id'):references('id'):on('users'):onUpdate('cascade'):onDelete('cascade')
        table:foreign('blog_id'):references('id'):on('blogs'):onUpdate('cascade'):onDelete('cascade')
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('blog_subscribers')
end

return _M

