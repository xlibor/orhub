
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'facade'
}

local app, lf, tb, str = lx.kit()

-- Get the registered name of the component.
-- @return string

function _M.s__.getFacadeAccessor()

    return 'rss'
end

return _M

