
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'job',
    _bond_ = 'selfHandling, ShouldQueue',
    _mix_ = 'interactsWithQueue, SerializesModels'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        user = nil,
        timeFrame = nil,
        content = nil
    }
    
    return oo(this, mt)
end

function _M:ctor(user, timeFrame, content)

    self.user = user
    self.timeFrame = timeFrame
    self.content = content
end

function _M:handle()

    return app('.app.lxhub.handler.emailHandler'):sendMaintainerWorksMail(self.user, self.timeFrame, self.content)
end

return _M

