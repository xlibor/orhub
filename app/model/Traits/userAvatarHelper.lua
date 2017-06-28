
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:cacheAvatar()

    --Download Image
    local guzzle = new('client')
    local response = guzzle:get(self.image_url)
    --Get ext
    local content_type = str.split(response:getHeader('Content-Type')[0], '/')
    local ext = tb.pop(content_type)
    local avatar_name = self.id .. '_' .. time() .. '.' .. ext
    local save_path = public_path('uploads/avatars/') .. avatar_name
    --Save File
    local content = response:getBody():getContents()
    file_put_contents(save_path, content)
    --Delete old file
    if self.avatar then
        @unlink(public_path('uploads/avatars/') .. self.avatar)
    end
    --Save to database
    self.avatar = avatar_name
    self:save()
end

function _M:updateAvatar(file)

    local upload_status = app('Phphub\\Handler\\ImageUploadHandler'):uploadAvatar(file, self)
    self.avatar = upload_status['filename']
    self:save()
    
    return {avatar = self.avatar}
end

return _M

