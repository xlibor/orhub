
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:index()

    local adverts = self.adverts:all()
    
    return self:response():collection(adverts, new('launchScreenAdvertTransformer'))
end

return _M

