
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('site_statuses', function(table)
        table:increments('id')
        table:string('day'):index()
        table:integer('register_count'):unsigned():default(0)
        table:integer('github_regitster_count'):unsigned():default(0)
        table:integer('wechat_registered_count'):unsigned():default(0)
        table:tinyInteger('topic_count'):unsigned():default(0)
        table:integer('reply_count'):unsigned():default(0)
        table:integer('image_count'):unsigned():default(0)
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('site_statuses')
end

return _M

