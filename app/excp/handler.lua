
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'exceptionHandler'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        dontReport = {HttpException.class, ModelNotFoundException.class}
    }
    
    return oo(this, mt)
end

-- A list of the exception types that should not be reported.
-- @var table
-- Report or log an exception.
-- This is a great spot to send exceptions to Sentry, Bugsnag, etc.
-- @param  \Exception  e


function _M:report(e)

    return parent.report(e)
end

-- Render an exception into an HTTP response.
-- @param  \Illuminate\Http\Request  request
-- @param  \Exception  e
-- @return \Illuminate\Http\Response

function _M:render(request, e)

    if e:__is('ModelNotFoundException') then
        e = new('notFoundHttpException', e:getMessage(), e)
    end
    if not config('app.debug') then
        
        return response():view('errors.500', {}, 500)
    end
    
    return parent.render(request, e)
end

return _M

