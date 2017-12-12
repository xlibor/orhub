
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'baseFormRequest'
}

local app, lf, tb, str, new = lx.kit()
local ImageUploadHandler = lx.use('.app.core.handler.imageUploadHandler')

function _M:authorize()

    return true
end

function _M:rules()

    local method, action = self.method, self.action
    if method == 'get' then
        
        return {}
    elseif action == 'store' then
        
        return {
            slug = 'between:2,45|regex:^[A-Za-z0-9\\-\\_]+$|required|unique:blogs',
            name = 'between:2,45|required|unique:blogs',
            description = 'max:250',
            cover = 'required|image'
        }
    elseif action == 'update' then
        blog = Blog.findOrFail(self:param('id'))
        
        return {
            slug = 'between:2,45|regex:^[A-Za-z0-9\\-\\_]+$|required|unique:blogs,slug,' .. blog.id,
            name = 'between:2,45|required|unique:blogs,name,' .. blog.id,
            description = 'max:250',
            cover = 'image'
        }
    end
end

function _M:performUpdate(blog)

    local upload_status

    blog.name = self:input("name")
    blog.slug = self:input("slug")
    blog.user_id = blog.user_id or Auth.id()
    blog.description = self:input("description")
    local file = self:file('cover')
    if file then
        upload_status = new(ImageUploadHandler):uploadImage(file)
        blog.cover = upload_status['filename']
    end
    
    return blog:save()
end

return _M

