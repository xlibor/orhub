
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        file = nil,
        allowed_extensions = {"png", "jpg", "gif", 'jpeg'}
    }
    
    return oo(this, mt)
end

-- @param uploadedFile file
-- @param user user
-- @return table

function _M:uploadAvatar(file, user)

    self.file = file
    self:checkAllowedExtensionsOrFail()
    local avatar_name = user.id .. '_' .. lf.time() .. '.' .. file:getClientOriginalExtension() or 'png'
    self:saveImageToLocal('avatar', 380, avatar_name)
    
    return {filename = avatar_name}
end

function _M:uploadImage(file)

    self.file = file
    self:checkAllowedExtensionsOrFail()
    local local_image = self:saveImageToLocal('topic', 1440)
    
    return {filename = get_user_static_domain() .. local_image}
end

function _M.__:checkAllowedExtensionsOrFail()

    local extension = str.lower(self.file:getClientOriginalExtension())
    if extension and not tb.inList(self.allowed_extensions, extension) then
        lx.throw(ImageUploadException, 'You can only upload image with extensions: ' .. str.join(',', self.allowed_extensions))
    end
end

function _M.__:saveImageToLocal(type, resize, filename)

    filename = filename or ''
    local img
    local folderName = type == 'avatar' and 'uploads/avatars' or 'uploads/images/' .. date("Ym", time()) .. '/' .. date("d", time()) .. '/' .. Auth.user().id
    local destinationPath = public_path() .. '/' .. folderName
    local extension = self.file:getClientOriginalExtension() or 'png'
    local safeName = filename or str.random(10) .. '.' .. extension
    self.file:move(destinationPath, safeName)
    if self.file:getClientOriginalExtension() ~= 'gif' then
        img = Image.make(destinationPath .. '/' .. safeName)
        img:resize(resize, nil, function(constraint)
            constraint:aspectRatio()
            constraint:upsize()
        end)
        img:save()
    end
    
    return folderName .. '/' .. safeName
end

return _M

