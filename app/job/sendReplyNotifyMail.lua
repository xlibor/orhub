
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'job',
    _bond_ = 'selfHandling, ShouldQueue',
    _mix_ = 'interactsWithQueue, SerializesModels'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        reply = nil
    }
    
    return oo(this, mt)
end

function _M:ctor(reply)

    self.reply = reply
end

function _M:handle()

    EmailHandler.sendReplyNotifyMail(self.reply)
end

return _M

