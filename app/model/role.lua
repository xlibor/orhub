
local lx, _M = oo{
    _cls_   = '',
    _ext_   = 'entrustRole',
}

local app, lf, tb, str, new = lx.kit()

function _M:ctor()

    self.fillable = {'name', 'display_name', 'description'}
end

function _M:boot()

    self:__super(_M, 'boot')
    
    -- static.saving(function(model)
    --     Cache.forget('all_assigned_roles')
    --     Cache.forget('all_roles')
    -- end)
end

function _M:addRole(name, display_name, description)

    local role = Role.query():where('name', name):first()
    if not role then
        role = new(Role, {name = name})
    end
    role.display_name = display_name
    role.description = description
    role:save()
    
    return role
end

function _M:allUsers()

    return self:belongsToMany(User)
end

function _M:relationArrayWithCache()

    local minutes = 60
    
    return Cache.remember('all_assigned_roles', minutes, function()
        
        return Db.table('role_user'):get()
    end)
end

function _M:rolesArrayWithCache()

    local minutes = 60
    
    return Cache.remember('all_roles', minutes, function()
        
        return Db.table('roles'):get()
    end)
end

return _M

