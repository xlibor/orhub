
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str, new = lx.kit()
local fair = lx.h.fair

function _M:run()

    local password = Hash('secret')
    local users = fair(User):times(49):make():each(function(user, i)
        if i == 1 then
            user.name = 'admin'
            user.email = 'admin@estgroupe.com'
            user.github_name = 'admin'
            user.verified = 1
        end
        user.password = password
        user.github_id = i
    end)

    new(User):inserts(users:toArr())
    local hall_of_fame = Role.addRole('HallOfFame', '名人堂')
    users = User.all()
    for key, user in pairs(users) do
        user:attachRole(hall_of_fame)
    end
end

return _M

