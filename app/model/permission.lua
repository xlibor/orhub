
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'entrustPermission',
    _static_    = {}
}

local app, lf, tb, str, new = lx.kit()

local static

function _M._init_(this)

    static = this.static
end

function _M:ctor()

    self.fillable = {'name', 'display_name', 'description'}
end

function _M.t__.addPermission(this, name, display_name, description)

    local permission = new(this):where('name', name):first()
    if not permission then
        permission = new(this, {name = name})
    end
    permission.display_name = display_name
    permission.description = description
    permission:save()
    
    return permission
end

return _M

