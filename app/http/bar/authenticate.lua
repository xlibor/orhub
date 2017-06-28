
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        auth = nil
    }
    
    return oo(this, mt)
end

-- The Guard implementation.
-- @var Guard
-- Create a new middleware instance.
-- @param  Guard  auth


function _M:ctor(auth)

    self.auth = auth
end

-- Handle an incoming request.
-- @param  \Illuminate\Http\Request  request
-- @param  \Closure  next
-- @return mixed

function _M:handle(request, next)

    if self.auth:guest() then
        if request:ajax() then
            
            return response('Unauthorized.', 401)
        else 
            
            return redirect():guest('login-required')
        end
    end
    
    return next(request)
end

return _M

