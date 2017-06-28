
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'testCase'
}

local app, lf, tb, str = lx.kit()

-- A basic functional test example.


function _M:testBasicExample()

    self:visit('/'):see('Laravel 5')
end

return _M

