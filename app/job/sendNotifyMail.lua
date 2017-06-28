
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'job',
    _bond_ = 'selfHandling, ShouldQueue',
    _mix_ = 'interactsWithQueue, SerializesModels'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        type = nil,
        fromUser = nil,
        toUser = nil,
        body = nil,
        topic = nil,
        reply = nil
    }
    
    return oo(this, mt)
end

function _M:ctor(type, fromUser, toUser, topic, reply, body)

    self.type = type
    self.fromUser = fromUser
    self.toUser = toUser
    self.topic = topic
    self.reply = reply
    self.body = body
end

function _M:handle()

    app('Phphub\\Handler\\EmailHandler'):sendNotifyMail(self.type, self.fromUser, self.toUser, self.topic, self.reply, self.body)
end

return _M

