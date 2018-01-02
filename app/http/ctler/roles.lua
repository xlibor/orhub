
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()
local use              = lx.use
local User             = use('.app.model.user')

function _M:show(c, id)

    local role = Role.findOrFail(id)
    local users = User.byRolesName(role.name)
    
    return c:view('roles.show', Compact('users', 'role'))
end

return _M

