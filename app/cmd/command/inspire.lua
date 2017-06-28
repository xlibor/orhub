
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'inspire',
        description = 'Display an inspiring quote'
    }
    
    return oo(this, mt)
end

-- The name and signature of the console command.
-- @var string
-- The console command description.
-- @var string
-- Execute the console command.
-- @return mixed

function _M:handle()

    self:comment(PHP_EOL .. Inspiring.quote() .. PHP_EOL)
end

return _M

