
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:issueAccessToken()

    return Response.json(Authorizer.issueAccessToken())
end

return _M

