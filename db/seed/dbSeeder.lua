
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()
local Model = lx.use('model')

function _M:new()

    local this = {
        seeders = {
            'usersTableSeeder', 'linksTableSeeder',
            'categoriesTableSeeder', 'blogTableSeeder',
            'topicsTableSeeder', 'repliesTableSeeder',
            'bannersTableSeeder', 'followersTableSeeder',
            'activeUsersTableSeeder', 'hotTopicsTableSeeder',
            'sitesTableSeeder', 'oauthClientsTableSeeder'
        }
    }
    
    return oo(this, mt)
end

function _M:run()

    Cache.enable(false)
    Ah.insanity_check()
    Model.unguard()
    for _, seedClass in ipairs(self.seeders) do
        seedClass = '.db.seed.' .. seedClass
        self:call(seedClass)
    end
    Model.reguard()

end

return _M

