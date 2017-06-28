
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
-- Create a new filter instance.
-- @param  Guard  auth


function _M:ctor(auth)

    self.auth = auth
end

-- Handle an incoming request.
-- @param  \Illuminate\Http\Request  request
-- @param  \Closure  next
-- @return mixed

function _M:handle(request, next)

    if self.auth:check() then
        
        return redirect('/')
    end
    
    return next(request)
end

return _M

