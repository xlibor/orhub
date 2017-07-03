
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'migration'
}

local app, lf, tb, str = lx.kit()

-- Run the migrations.


function _M:up(schema)

    schema:create('notification_mail_logs', function(table)
        table:increments('id')
        table:integer('from_user_id'):unsigned():default(0):index()
        table:integer('user_id'):unsigned():default(0):index()
        table:integer('topic_id'):unsigned():default(0):index()
        table:integer('reply_id'):unsigned():default(0):index()
        table:string('type'):index()
        table:text('body'):nullable()
        table:timestamps()
    end)
end

-- Reverse the migrations.


function _M:down(schema)

    schema:drop('notification_mail_logs')
end

return _M

