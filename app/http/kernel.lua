
local _M = {
    _cls_ = '',
    _ext_ = {
        path = 'lxlib.http.kernel'
    },
    bars = {
    },
    routeBars = {
        {'auth',        'lxlib.auth.bar.authenticate'},
        {'auth.basic',  'lxlib.auth.bar.authenticateWithBasicAuth'},
        {'can',         'lxlib.auth.bar.authorize'},
        {'guest',       '.app.http.bar.redirectIfAuthenticated'},
        -- {'adminAuth',       '.app.http.bar.adminAuth'},
        -- {'verifiedEmail',   '.app.http.bar.RequireVerifiedEmail'},
        -- {'oauth2',          '.app.http.bar.oauth2'},
        -- {'check-authorization-params', 'LucaDegasperi.OAuth2Server.Middleware.CheckAuthCodeRequest',
        -- {'restrict_web_access', '.app.http.bar.restrictWebAccess'}
    },
    barGroup = {
        web = {
            'lxlib.cookie.bar.addToResponse',
            'lxlib.session.bar.startSession',
            'lxlib.view.bar.shareErrorsFromSession',
            '.app.http.bar.verifyCsrfToken',
            -- '.app.http.bar.CheckUserIsItBanned',
            -- '.app.http.bar.RecordLastActivedTime',
            -- 'spatie.pjax.bar.filterIfPjax',
            -- 'lucaDegasperi.oAuth2Server.bar.oAuthExceptionHandler',
        }
    }
}

function _M:ctor()

    self:initBars()
end

return _M

