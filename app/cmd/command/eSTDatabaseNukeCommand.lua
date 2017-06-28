
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseCommand'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'est:dbnuke {--force : enforce}',
        description = 'Delete all tables'
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    self:productionCheckHint()
    local colname = 'Tables_in_' .. env('DB_DATABASE')
    local tables = DB.select('SHOW TABLES')
    for _, table in pairs(tables) do
        tapd(droplist, table.[colname])
        self:info('Will delete table - ' .. table.[colname])
    end
    if not droplist then
        self:error('No table')
        
        return
    end
    local droplist = str.join(droplist, ',')
    DB.beginTransaction()
    --turn off referential integrity
    DB.statement('SET FOREIGN_KEY_CHECKS = 0')
    DB.statement("DROP TABLE {droplist}")
    --turn referential integrity back on
    DB.statement('SET FOREIGN_KEY_CHECKS = 1')
    DB.commit()
    self:comment("All the tables have been deleted" .. PHP_EOL)
end

return _M

