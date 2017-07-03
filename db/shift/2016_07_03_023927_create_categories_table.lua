
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('categories', function(table)
        table:increments('id')
        table:integer('parent_id'):default(0):comment('父级 id')
        table:integer('post_count'):default(0):comment('帖子数')
        table:tinyInteger('weight'):default(0):comment('权重')
        table:string('name'):index():comment('名称')
        table:string('slug', 60):unique():comment('缩略名')
        table:string('description'):nullable():comment('描述')
        table:timestamps()
        table:softDeletes()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('categories')
end

return _M

