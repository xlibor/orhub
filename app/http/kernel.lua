
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'httpKernel'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        middleware = {\Illuminate\Foundation\Http\Middleware\CheckForMaintenanceMode.class, \App\Http\Middleware\EncryptCookies.class, \Illuminate\Cookie\Middleware\AddQueuedCookiesToResponse.class, \Illuminate\Session\Middleware\StartSession.class, \Illuminate\View\Middleware\ShareErrorsFromSession.class, \App\Http\Middleware\VerifyCsrfToken.class, \App\Http\Middleware\CheckUserIsItBanned.class, \App\Http\Middleware\RecordLastActivedTime.class, \Spatie\Pjax\Middleware\FilterIfPjax.class, \LucaDegasperi\OAuth2Server\Middleware\OAuthExceptionHandlerMiddleware.class},
        routeMiddleware = {
        auth = \App\Http\Middleware\Authenticate.class,
        ['auth.basic'] = \Illuminate\Auth\Middleware\AuthenticateWithBasicAuth.class,
        guest = \App\Http\Middleware\RedirectIfAuthenticated.class,
        admin_auth = \App\Http\Middleware\AdminAuth.class,
        verified_email = \App\Http\Middleware\RequireVerifiedEmail.class,
        oauth2 = \App\Http\Middleware\OAuthMiddleware.class,
        ['check-authorization-params'] = \LucaDegasperi\OAuth2Server\Middleware\CheckAuthCodeRequestMiddleware.class,
        ['api.throttle'] = \Dingo\Api\Http\Middleware\RateLimit.class,
        restrict_web_access = \App\Http\Middleware\RestrictWebAccess.class
    }
    }
    
    return oo(this, mt)
end

-- The application's global HTTP middleware stack.
-- @var table
-- The application's route middleware.
-- @var table

return _M

