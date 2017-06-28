
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'request'
}

local app, lf, tb, str = lx.kit()

function _M:authorize()

    return true
end

function _M:rules()

    local st = self:method()
    if st == 'GET' then
    elseif st == 'DELETE' then
        
        return {}
        -- Crate
    elseif st == 'POST' then
        
        return {
            slug = 'between:2,25|regex:/^[A-Za-z0-9\\-\\_]+$/|required|unique:blogs',
            name = 'between:2,20|required|unique:blogs',
            description = 'max:250',
            cover = 'required|image'
        }
        -- UPDATE
    elseif st == 'PUT' then
    elseif st == 'PATCH' then
        blog = Blog.findOrFail(self:route('id'))
        
        return {
            slug = 'between:2,25|regex:/^[A-Za-z0-9\\-\\_]+$/|required|unique:blogs,slug,' .. blog.id,
            name = 'between:2,20|required|unique:blogs,name,' .. blog.id,
            description = 'max:250',
            cover = 'image'
        }
    else 
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
        upload_status = app('Phphub\\Handler\\ImageUploadHandler'):uploadImage(file)
        blog.cover = upload_status['filename']
    end
    
    return blog:save()
end

return _M

