
local lx, _M = oo{
	_cls_ = ''
}

local redirect = lx.h.redirect

function _M:handle(ctx, next, guard)

    if Auth.guard(guard):check() then
        
        return redirect():route('post.index')
    end
    
    return next(ctx)
end

return _M

