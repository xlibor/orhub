
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

function _M:up(schema)

    schema:create('blog_topics', function(table)
        table:integer('blog_id'):unsigned():index()
        table:integer('topic_id'):unsigned():index()
        table:foreign('blog_id'):references('id'):on('blogs'):onUpdate('cascade'):onDelete('cascade')
        table:foreign('topic_id'):references('id'):on('topics'):onUpdate('cascade'):onDelete('cascade')
    end)
end

function _M:down(schema)

    schema:drop('blog_topics')
end

return _M

