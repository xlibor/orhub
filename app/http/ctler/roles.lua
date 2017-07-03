
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:show(id)

    local role = Role.findOrFail(id)
    local users = User.byRolesName(role.name)
    
    return view('roles.show', Compact('users', 'role'))
end

return _M

