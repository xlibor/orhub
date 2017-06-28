
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'serviceProvider'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        defer = true
    }
    
    return oo(this, mt)
end

function _M:register()

    app:single('Phphub\\Markdown\\Markdown', function(app)
        
        return new('\Phphub\Markdown\Markdown')
    end)
end

function _M:provides()

    return {'Phphub\\Markdown\\Markdown'}
end

return _M

