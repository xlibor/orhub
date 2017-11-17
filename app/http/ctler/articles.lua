
local lx, _M, mt = oo{
    _cls_       = '',
    _ext_       = 'controller',
    _bond_      = 'creatorListener'
}

local app, lf, tb, str, new = lx.kit()
local use, lh       = lx.use, lx.h
local redirect      = lh.redirect
local lang          = Ah.lang
local TopicDoer     = use('.app.http.doer.topic')

function _M:ctor()

    self:setBar('auth', {except = {'index', 'show'}})
end

function _M:create(c)

    local request = c.req
    local user = Auth.user()
    if user:blogs():count() <= 0 then
        Flash.info('请先创建专栏，专栏创建成功后才能发布文章。')
        
        return redirect():route('blogs.create')
    end
    local topic = new('.app.model.topic')
    local blogId = request:input('blog_id')
    local blog = blogId and Blog.findOrFail(blogId) or Auth.user():blogs():first()
    self:authorize('create-article', blog)
    
    return c:view('articles.create_edit', Compact('topic', 'user', 'blog'))
end

function _M:store(c)

    local request = c:form('storeTopicRequest')
    
    local data = request:except('_token')
    local blog = Blog.findOrFail(request.blog_id)
    self:authorize('create-article', blog)
    data.blog_id = blog.id
    if request.subject == 'draft' then
        data.is_draft = 'yes'
    end
    
    return new(TopicDoer):create(self, data, blog)
end

function _M:transform(c, id)

    Auth.user():decrement('topic_count', 1)
    Auth.user():increment('article_count', 1)
    if Auth.user():blogs():count() <= 0 then
        Flash.info('请先创建专栏，专栏创建成功后才能发布文章。')
        
        return redirect():route('blogs.create')
    end
    local topic = Topic.find(id)
    topic:update({category_id = Conf('lxhub.blogCategoryId')})
    -- attach blog
    local blog = Auth.user():blogs():first()
    blog:topics():attach(topic.id)
    blog:increment('article_count', 1)

    if not blog:authors():where('user_id', topic.user_id):exists() then
        blog:authors():attach(topic.user_id)
    end
    Flash.success(lang('Operation succeeded.'))
    
    return redirect():to(topic:link())
end

function _M:show(c, id)

    -- See: TopicsController->show
end

function _M:edit(c, id)

    local topic = Topic.findOrFail(id)
    
    return c:view('articles.create_edit', Compact('topic'))
end

function _M:update(c, id)

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

