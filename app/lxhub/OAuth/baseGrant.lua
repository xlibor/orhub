
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'abstractGrant'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        identifier = nil,
        responseType = nil,
        callback = nil,
        accessTokenTTL = nil
    }
    
    return oo(this, mt)
end

-- Grant identifier.
-- @var string
-- Response type.
-- @var string
-- Callback to authenticate a user's name and password.
-- @var func
-- Access token expires in override.
-- @var int
-- Set the callback to verify a user's username and password.
-- @param func callback The callback function

function _M:setVerifyCredentialsCallback(callback)

    self.callback = callback
end

-- Return the callback function.
-- @return func
-- @throws

function _M.__:getVerifyCredentialsCallback()

    if not self.callback or not lf.isCallable(self.callback) then
        lx.throw(ServerErrorException, 'Null or non-callable callback set on Password grant')
    end
    
    return self.callback
end

-- Complete the password grant.
-- @return table
-- @throws

function _M:completeFlow()

    local refreshToken
    local client = self:getClient()
    local userId = self:getUserId(self.server:getRequest(), self:getVerifyCredentialsCallback())
    if userId == false then
        self.server:getEventEmitter():emit(new('userAuthenticationFailedEvent', self.server:getRequest()))
        lx.throw(InvalidCredentialsException)
    end
    -- Create a new session
    local session = new('sessionEntity', self.server)
    session:setOwner('user', userId)
    session:associateClient(client)
    -- Generate an access token
    local accessToken = new('accessTokenEntity', self.server)
    accessToken:setId(SecureKey.generate())
    accessToken:setExpireTime(self:getAccessTokenTTL() + time())
    self.server:getTokenType():setSession(session)
    self.server:getTokenType():setParam('access_token', accessToken:getId())
    self.server:getTokenType():setParam('expires_in', self:getAccessTokenTTL())
    -- Save everything
    session:save()
    accessToken:setSession(session)
    accessToken:save()
    -- Associate a refresh token if set
    if self.server:hasGrantType('refresh_token') then
        refreshToken = new('refreshTokenEntity', self.server)
        refreshToken:setId(SecureKey.generate())
        refreshToken:setExpireTime(self.server:getGrantType('refresh_token'):getRefreshTokenTTL() + time())
        self.server:getTokenType():setParam('refresh_token', refreshToken:getId())
        refreshToken:setAccessToken(accessToken)
        refreshToken:save()
    end
    
    return self.server:getTokenType():generateResponse()
end

-- 根据请求的 client_id 和 client_secret 获取 ClientEntity.
-- @throws InvalidClientException
-- @throws InvalidRequestException
-- @return ClientEntity

function _M.__:getClient()

    -- Get the required params
    local clientId = self.server:getRequest().request:get('client_id', self.server:getRequest():getUser())
    if not clientId then
        lx.throw(InvalidRequestException, 'client_id')
    end
    local clientSecret = self.server:getRequest().request:get('client_secret', self.server:getRequest():getPassword())
    if not clientSecret then
        lx.throw(InvalidRequestException, 'client_secret')
    end
    -- Validate client ID and client secret
    local client = self.server:getClientStorage():get(clientId, clientSecret, nil, self:getIdentifier())
    if client:__is('ClientEntity') == false then
        self.server:getEventEmitter():emit(new('clientAuthenticationFailedEvent', self.server:getRequest()))
        lx.throw(InvalidClientException)
    end
    
    return client
end

-- 获取 UserId.
-- @param request
-- @param verifier
-- @return int

function _M:getUserId(request, verifier) end

return _M

