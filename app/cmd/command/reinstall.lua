
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseCommand'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'est:reinstall {--force : enforce}',
        description = "Reset database, reset RABC. Only use in local environment"
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    self:productionCheckHint('Reset database and reset RABC')
    -- fixing db:seed class not found
    self:execShellWithPrettyPrint('composer dump')
    self:execShellWithPrettyPrint('php artisan est:dbreset --force')
    self:execShellWithPrettyPrint('php artisan est:init-rbac')
    self:execShellWithPrettyPrint('php artisan cache:clear')
    self:printBenchInfo()
end

return _M

