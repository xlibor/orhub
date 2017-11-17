
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str, new = lx.kit()
local try = lx.try
local redirect, lang = lx.h.redirect, Ah.lang
local UserSubscribedBlog = lx.use('.app.activity.userSubscribedBlog')

function _M:ctor()

    self:setBar('auth', {except = {'index', 'show'}})
end

function _M:create(c)

    local user = Auth.user()
    local blog = Blog.firstOrNew({user_id = Auth.id()})
    
    return c:view('blogs.create_edit', Compact('user', 'blog'))
end

function _M:show(c, name)

    local blog = Blog.where('slug', name):firstOrFail()
    local user = blog('user')
    local topics = blog:topics():onlyArticle():withoutDraft():recent():paginate(28)
    local authors = blog('authors')
    blog:update({article_count = topics:total()})
    
    c:view('blogs.show', Compact('user', 'blog', 'topics', 'authors'))
end

function _M:store(c)


    local file = c.req:file('cover')
    local request = c:form('blogStoreRequest')
    
    local blog = new(Blog)
    local ok, ret = try(function()
        request:performUpdate(blog)
        Flash.success(lang('Operation succeeded.'))
    end)
    :catch('imageUploadException', function(e) 
        Flash.error(lang(e:getMsg()))
        
        return redirect():back():withInput(request:input())
    end)
    :run()
    
    if ok and ret then return ret end

    return redirect():route('blogs.edit', blog.id)
end

function _M:edit(c, id)

    local user = Auth.user()
    local blog = Blog.findOrFail(id)
    
    return c:view('blogs.create_edit', Compact('blog', 'user'))
end

function _M:update(c, id)

    local request = c:form('blogStoreRequest')
    local blog = Blog.findOrFail(id)

    local ok, ret = try(function()
        request:performUpdate(blog)
        Flash.success(lang('Operation succeeded.'))
    end)
    :catch('imageUploadException', function(e) 
        Flash.error(lang(e:getMsg()))
        
        return redirect():back():withInput(request:input())
    end)
    :run()
    
    if ok and ret then return ret end

    return redirect():route('blogs.edit', blog.id)
end

function _M:subscribe(c, id)

    local blog = Blog.findOrFail(id)
    Auth.user():subscribes():attach(blog.id)
    blog:increment('subscriber_count', 1)
    Flash.success("订阅成功")
    app(UserSubscribedBlog):generate(Auth.user(), blog)
    
    return redirect():back()
end

function _M:unsubscribe(c, id)

    local blog = Blog.findOrFail(id)
    Auth.user():subscribes():detach(blog.id)
    blog:decrement('subscriber_count', 1)
    Flash.success("成功取消订阅")
    app(UserSubscribedBlog):remove(Auth.user(), blog)
    
    return redirect():back()
end

return _M

