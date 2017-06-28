
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'illuminate\Foundation\Testing\TestCase'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        baseUrl = 'http://localhost'
    }
    
    return oo(this, mt)
end

-- The base URL to use while testing the application.
-- @var string
-- Creates the application.
-- @return \Illuminate\Foundation\Application

function _M:createApplication()

    local app = (require __DIR__ .. '/../bootstrap/app.php')
    app:make(Illuminate\Contracts\Console\Kernel.class):bootstrap()
    
    return app
end

return _M

