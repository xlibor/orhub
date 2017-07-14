
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    _bond_ = 'creatorListener'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self:middleware('auth', {except = {'index', 'show'}})
end

function _M:create(request)

    local user = Auth.user()
    if user:blogs():count() <= 0 then
        Flash.info('请先创建专栏，专栏创建成功后才能发布文章。')
        
        return redirect():route('blogs.create')
    end
    local topic = new('topic')
    local blog = request.blog_id and Blog.findOrFail(request.blog_id) or Auth.user():blogs():first()
    self:authorize('create-article', blog)
    
    return view('articles.create_edit', Compact('topic', 'user', 'blog'))
end

function _M:store(request)

    local data = request:except('_token')
    local blog = Blog.findOrFail(request.blog_id)
    self:authorize('create-article', blog)
    data['blog_id'] = blog.id
    if request.subject == 'draft' then
        data['is_draft'] = 'yes'
    end
    
    return app('lxhub\\Creators\\TopicCreator'):create(self, data, blog)
end

function _M:transform(id)

    Auth.user():decrement('topic_count', 1)
    Auth.user():increment('article_count', 1)
    if Auth.user():blogs():count() <= 0 then
        Flash.info('请先创建专栏，专栏创建成功后才能发布文章。')
        
        return redirect():route('blogs.create')
    end
    local topic = Topic.find(id)
    topic:update({category_id =Conf('lxhub.blogCategoryId')})
    -- attach blog
    local blog = Auth.user():blogs():first()
    blog:topics():attach(topic.id)
    blog:increment('article_count', 1)
    -- Co-authors
    if not blog:authors():where('user_id', topic.user_id):exists() then
        blog:authors():attach(topic.user_id)
    end
    Flash.success(lang('Operation succeeded.'))
    
    return redirect():to(topic:link())
end

function _M:show(id)

    -- See: TopicsController->show
end

function _M:edit(id)

    local topic = Topic.findOrFail(id)
    
    return view('articles.create_edit', Compact('topic'))
end

function _M:update(id, request)

    -- See: TopicsController->update
end

------------------------------------------
-- CreatorListener Delegate
------------------------------------------

function _M:creatorFailed(error)

    Flash.error('发布失败：' .. error)
    
    return redirect():back()
end

function _M:creatorSucceed(topic)

    Flash.success(lang('Operation succeeded.'))
    
    return redirect():to(topic:link())
end

return _M

