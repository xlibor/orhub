
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseCommand'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'est:dbreset {--force : enforce}',
        description = "Delete all tables（use est:dbnuke ）, and run the 'migrate' and 'db:seed' commands"
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    self:productionCheckHint("Will delete all tables, and run the 'migrate' and 'db:seed' commands")
    self:call('est:dbnuke', {['--force'] = 'yes'})
    self:call('migrate', {['--seed'] = 'yes', ['--force'] = 'yes'})
end

return _M

