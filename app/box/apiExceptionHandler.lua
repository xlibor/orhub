
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'box'
}

local app, lf, tb, str = lx.kit()

-- Bootstrap the application services.

function _M:boot()

    local handler = app('api.exception')
    handler:register(function(exception)
        lx.throw(NotFoundHttpException)
    end)
end

-- Register the application services.

function _M:register()

end

return _M

