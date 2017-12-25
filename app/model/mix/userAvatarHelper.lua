
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()
local fs                    = lx.fs

local ImageUploadHandler    = lx.use('.app.core.handler.imageUploadHandler')

function _M:cacheAvatar()

    if lf.isEmpty(self.image_url) then
        return
    end

    --Download Image
    local hc = new('net.http.client')
    local response = hc:get(self.image_url)
    --Get ext
    local content_type = str.split(response:getHeader('Content-Type'), '/')
    local ext = tb.pop(content_type)
    local avatar_name = self.id .. '_' .. lf.time() .. '.' .. ext
    local save_path = lx.dir('pub', 'uploads/avatars/') .. avatar_name
    --Save File
    local content = response:getBody()
    fs.put(save_path, content)
    --Delete old file
    if self.avatar then
        fs.delete(lx.dir('tmp', 'upload/avatars/') .. self.avatar)
    end
    --Save to database
    self.avatar = avatar_name
    self:save()
end

function _M:updateAvatar(file)

    local upload_status = new(ImageUploadHandler):uploadAvatar(file, self)
    self.avatar = upload_status['filename']
    self:save()
    
    return {avatar = self.avatar}
end

return _M

