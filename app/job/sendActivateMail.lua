
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'job',
    _bond_ = 'selfHandling, ShouldQueue',
    _mix_ = 'interactsWithQueue, SerializesModels'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        user = nil
    }
    
    return oo(this, mt)
end

function _M:ctor(user)

    self.user = user
end

function _M:handle()

    return app('Phphub\\Handler\\EmailHandler'):sendActivateMail(self.user)
end

return _M

