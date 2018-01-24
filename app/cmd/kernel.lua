
local _M = {
    _cls_ = '',
    _ext_ = {
        path = 'lxlib.console.kernel'
    }
}

local lx    = require('lxlib')
local env   = lx.env

function _M:loadCommands(cmder)

    cmder:group('.app.cmd.command', function()
        require('.map.cmd')(cmder)
    end)

    if env('toolMode') then
        cmder:group('orhubtool.command', function()
            require('orhubtool.cmd')(cmder)
        end)
    end
end

function _M:loadSchedule(schedule)

    require('.map.task')(schedule)
end

return _M

