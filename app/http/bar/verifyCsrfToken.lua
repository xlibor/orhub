
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseVerifier'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        except = {}
    }
    
    return oo(this, mt)
end

-- The URIs that should be excluded from CSRF verification.
-- @var table
function _M:handle(request, next)

    if not request:is('v1/*') then
        
        return parent.handle(request, next)
    end
    
    return next(request)
end

return _M

