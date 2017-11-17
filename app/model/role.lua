
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'entrustRole',
    _static_    = {
    }
}

local app, lf, tb, str, new = lx.kit()

local static

function _M._init_(this)

    static = this.static
end

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

function _M.t__.addRole(this, name, display_name, description)

    local role = new(this):where('name', name):first()
    if not role then
        role = new(this, {name = name})
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

