
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:getDataFromUserName(username)

    local client = new('client', {base_uri = 'https://api.github.com/users/'})
    query['client_id'] = Conf('service .github.client_id')
    query['client_secret'] = Conf('service.github.client_secret')
    local data = client:get(username, query):getBody():getContents()
    
    return lf.jsde(data, true)
end

return _M

