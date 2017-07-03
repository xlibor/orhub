
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('banners', function(table)
        table:increments('id')
        table:string('position'):index()
        table:integer('order'):unsigned():default(0):index()
        table:string('image_url')
        table:string('title'):index()
        table:string('link'):nullable()
        table:enum('target', {'_blank', '_self'}):default('_blank'):index()
        table:text('description'):nullable()
        table:softDeletes()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('banners')
end

return _M

