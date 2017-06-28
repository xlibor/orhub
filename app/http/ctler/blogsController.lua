
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self:middleware('auth', {except = {'index', 'show'}})
end

function _M:create()

    local user = Auth.user()
    local blog = Blog.firstOrNew({user_id = Auth.id()})
    
    return view('blogs.create_edit', compact('user', 'blog'))
end

function _M:show(name)

    local blog = Blog.where('slug', name):firstOrFail()
    local user = blog.user
    local topics = blog:topics():onlyArticle():withoutDraft():recent():paginate(28)
    local authors = blog.authors
    blog:update({article_count = topics:total()})
    
    return view('blogs.show', compact('user', 'blog', 'topics', 'authors'))
end

function _M:store(request)

    local blog = new('blog')
    try(function()
        request:performUpdate(blog)
        Flash.success(lang('Operation succeeded.'))
    end)
    :catch(function(ImageUploadException exception) 
        Flash.error(lang(exception:getMessage()))
        
        return redirect():back():withInput(request:input())
    end)
    :run()
    
    return redirect():route('blogs.edit', blog.id)
end

function _M:edit(id)

    local user = Auth.user()
    local blog = Blog.findOrFail(id)
    
    return view('blogs.create_edit', compact('blog', 'user'))
end

function _M:update(request, id)

    local blog = Blog.findOrFail(id)
    -- this->authorize('update', blog);
    try(function()
        request:performUpdate(blog)
        Flash.success(lang('Operation succeeded.'))
    end)
    :catch(function(ImageUploadException exception) 
        Flash.error(lang(exception:getMessage()))
        
        return redirect():back():withInput(request:input())
    end)
    :run()
    
    return redirect():route('blogs.edit', blog.id)
end

function _M:subscribe(id)

    local blog = Blog.findOrFail(id)
    Auth.user():subscribes():attach(blog.id)
    blog:increment('subscriber_count', 1)
    Flash.success("订阅成功")
    app(UserSubscribedBlog.class):generate(Auth.user(), blog)
    
    return redirect():back()
end

function _M:unsubscribe(id)

    local blog = Blog.findOrFail(id)
    Auth.user():subscribes():detach(blog.id)
    blog:decrement('subscriber_count', 1)
    Flash.success("成功取消订阅")
    app(UserSubscribedBlog.class):remove(Auth.user(), blog)
    
    return redirect():back()
end

return _M

