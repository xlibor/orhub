
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseEncrypter'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        except = {}
    }
    
    return oo(this, mt)
end

-- The names of the cookies that should not be encrypted.
-- @var table

return _M

