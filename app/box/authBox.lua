
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'box'
}

local app, lf, tb, str = lx.kit()

function _M:reg()

end

function _M:boot()

    local policies = {
        ['app.model']           = 'app.policy.modelPolicy',
        ['.app.model.user']     = '.app.policy.userPolicy',
        ['.app.model.topic']    = '.app.policy.topicPolicy',
        ['.app.model.reply']    = '.app.policy.replyPolicy',
        ['.app.model.blog']     = '.app.policy.blogPolicy',
        ['.app.model.thread']   = '.app.policy.threadPolicy'
    }

    local gate = app.gate
    for k, v in pairs(policies) do
        gate:policy(k, v)
    end
end

return _M

