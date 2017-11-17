
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.description = 'Project Initialize Command'
end

function _M:run()

    app:run('shift/reset')
    app:run('shift')
    app:run('seed')
    app:run('lxhub/initRbac')
end

return _M

