
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'entrustPermission',
    _static_    = {}
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.fillable = {'name', 'display_name', 'description'}
end

function _M.s__.addPermission(name, display_name, description)

    local permission = Permission.where('name', name):first()
    if not permission then
        permission = new('permission', {name = name})
    end
    permission.display_name = display_name
    permission.description = description
    permission:save()
    
    return permission
end

return _M

