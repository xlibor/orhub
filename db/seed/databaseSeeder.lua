
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        seeders = {'UsersTableSeeder', 'LinksTableSeeder', 'CategoriesTableSeeder', 'BlogTableSeeder', 'TopicsTableSeeder', 'RepliesTableSeeder', 'BannersTableSeeder', 'FollowersTableSeeder', 'ActiveUsersTableSeeder', 'HotTopicsTableSeeder', 'SitesTableSeeder', 'OauthClientsTableSeeder'}
    }
    
    return oo(this, mt)
end

function _M:run()

    insanity_check()
    Model.unguard()
    for _, seedClass in pairs(self.seeders) do
        self:call(seedClass)
    end
    Model.reguard()
end

return _M

