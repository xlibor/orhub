
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'request'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        allowed_fields = {'github_name', 'real_name', 'city', 'gender', 'company', 'twitter_account', 'personal_website', 'introduction', 'weibo_name', 'weibo_link', 'email', 'linkedin', 'signature'}
    }
    
    return oo(this, mt)
end

function _M:authorize()

    return true
end

function _M:rules()

    return {
        github_id = 'unique:users',
        github_name = 'string',
        wechat_openid = 'string',
        email = 'email|unique:users,email,' .. self.id,
        github_url = 'url',
        image_url = 'url',
        wechat_unionid = 'string',
        linkedin = 'url',
        weibo_link = 'url',
        payment_qrcode = 'image',
        wechat_qrcode = 'image'
    }
end

function _M:performUpdate(user)

    local upload_status
    local data = self:only(self.allowed_fields)
    local old_email = user.email
    -- A dirty fix for api client
    if is_request_from_api() and self:get('signature') and not self:get('introduction') then
        data['introduction'] = self:get('signature')
    end
    local file = self:file('payment_qrcode')
    -- 微信支付二维码
    if file then
        upload_status = app('Phphub\\Handler\\ImageUploadHandler'):uploadImage(file)
        data['payment_qrcode'] = upload_status['filename']
    end
    local file = self:file('wechat_qrcode')
    -- 微信二维码
    if file then
        upload_status = app('Phphub\\Handler\\ImageUploadHandler'):uploadImage(file)
        data['wechat_qrcode'] = upload_status['filename']
    end
    user:update(data)
    if user.email and user.email ~= old_email then
        dispatch(new('sendActivateMail', user))
    end
    
    return user
end

return _M

