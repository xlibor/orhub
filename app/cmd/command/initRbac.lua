
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str, new = lx.kit()
local use = lx.ns('.app.model')
local Permission, Role = use('permission', 'role')

function _M:ctor()

    self.description = 'Initialize Role Based Access Control'
end

function _M:run()

    local user = User.first()
    if not user then
        self:error("Users table is empty")
        
        return
    end

    local founder = Role.addRole('Founder', 'Founder')
    local maintainer = Role.addRole('Maintainer', 'Maintainer')
    local contributor = Role.addRole('Contributor', 'Contributor')
    local visit_admin = Permission.addPermission('visit_admin', 'Visit Admin')
    local manage_users = Permission.addPermission('manage_users', 'Manage Users')
    local manage_topics = Permission.addPermission('manage_topics', 'Manage Topics')
    local compose_announcement = Permission.addPermission('compose_announcement', 'Composing Announcement')
    self:attachPermissions(founder, {visit_admin, manage_users, manage_topics, compose_announcement})
    self:attachPermissions(maintainer, {visit_admin, manage_topics, compose_announcement})
    if not user:hasRole(founder.name) then
        user:attachRole(founder)
    end
    self:info('--')
    self:info("Initialize RABC success -- ID: 1 and Name “" .. user.name .. "” has founder permission")
    self:info('--')
end

function _M:attachPermissions(role, permissions)

    local attach = {}
    permissions = lx.arr(permissions)
    local detach = {}
    for _, permission in ipairs(role:perms():get()) do
        if permissions:where('name', permission.name):isEmpty() then
            tapd(detach, permission)
        end
    end
    for _, permission in ipairs(permissions:all()) do
        if not role:hasPermission(permission.name) then
            tapd(attach, permission)
        end
    end
    role:detachPermissions(detach)
    role:attachPermissions(attach)
end

return _M

