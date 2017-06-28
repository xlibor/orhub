
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        bench = nil
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
    self.bench = new('ubench')
    self.bench:start()
    self.is_ask = false
end

function _M:printBenchInfo()

    -- 统计结束，可以打印出信息了
    self.bench:end()
    self:info('-------')
    self:info('-------')
    self:info(fmt("Command execution completed, time consuming: %s, memory usage: %s ", self.bench:getTime(), self.bench:getMemoryUsage()))
    self:info('-------')
    self:info('-------')
end

function _M:execShellWithPrettyPrint(command)

    self:info('---')
    self:info(command)
    local output = shell_exec(command)
    self:info(output)
    self:info('---')
end

function _M:productionCheckHint(message)

    message = message or ''
    message = message or 'This is a "very dangerous" operation'
    if App.environment('production') and not self:option('force') and not self:confirm('Your are in「Production」environment, ' .. message .. '! Are you sure you want to do this? [y|N]') then
        exit('Command termination')
    end
end

return _M

