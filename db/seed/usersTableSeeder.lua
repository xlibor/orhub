
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    local password = bcrypt('secret')
    local users = factory(User.class):times(49):make():each(function(user, i)
        if i == 0 then
            user.name = 'admin'
            user.email = 'admin@estgroupe.com'
            user.github_name = 'admin'
            user.verified = 1
        end
        user.password = password
        user.github_id = i + 1
    end)
    User.insert(users:toArray())
    local hall_of_fame = Role.addRole('HallOfFame', '名人堂')
    users = User.all()
    for key, user in pairs(users) do
        user:attachRole(hall_of_fame)
    end
end

return _M

