
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'entrustPermission'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        fillable = {'name', 'display_name', 'description'}
    }
    
    return oo(this, mt)
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

