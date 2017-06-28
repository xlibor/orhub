
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseCommand'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'est:install {--force : enforce}',
        description = 'Project Initialize Command'
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    self:execShellWithPrettyPrint('php artisan key:generate')
    self:execShellWithPrettyPrint('php artisan migrate --seed')
    self:execShellWithPrettyPrint('php artisan est:init-rbac')
end

return _M

