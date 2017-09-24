
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    -- _bond_ = 'creatorListener'
}

local app, lf, tb, str, new = lx.kit()
local redirect = lx.h.redirect
local lang = Ah.lang

function _M:ctor()

    self:setBar('auth', {except = {'index', 'show'}})
end

function _M:index(c)

    local request = c.req
    local topics = new(Topic):getTopicsWithFilter(request:get('filter', 'index'), 40)

    -- dd(topics.items:count())
    local links = Link.allFromCache()
    local active_users = ActiveUser.fetchAll()
    local hot_topics = HotTopic.fetchAll()
    
    c:view('topics.index', Compact('topics', 'links', 'banners', 'active_users', 'hot_topics'))
end

function _M:create(c)

    local request = c.req
    local categoryId = request:input('category_id')
    local category
    if categoryId then
        category = Category.find(categoryId)
    end
    local categories = Category.where('id', '!=', app:conf('lxhub.blogCategoryId')):get()
    
    return c:view('topics.create_edit', Compact('categories', 'category'))
end

function _M:store(c)

    local request = c.req
    return app('.app.lxhub.creator.topic'):create(self, request:except('_token'))
end

function _M:show(c, id, fromCode)

    local request = c.req

    fromCode = fromCode or false
    local userTopics
    local blog
    local user
    local topic = Topic.where('id', id):with('user', 'lastReplyUser'):firstOrFail()
    if topic:isArticle() and topic.is_draft == 'yes' then
        self:authorize('show_draft', topic)
    end
    -- URL 矫正

    local slug = request:param('slug')

    if not lf.isEmpty(topic.slug) and topic.slug ~= slug and not fromCode then
        
        return redirect(topic:link(), 301)
    end
    if topic('user').is_banned == 'yes' then
        -- 未登录，或者已登录但是没有管理员权限
        if not Auth.check() or Auth.check() and not Auth.user():may('manage_topics') then
            Flash.error('你访问的文章已被屏蔽，有疑问请发邮件：all@estgroupe.com')
            
            return redirect(route('topics.index'))
        end
        Flash.error('当前文章的作者已被屏蔽，游客与用户将看不到此文章。')
    end
    if Conf('lxhub.adminBoardCid') and topic.id ==Conf('lxhub.adminBoardCid') and (not Auth.check() or not Auth.user():can('access_board')) then
        Flash.error('您没有权限访问该文章，有疑问请发邮件：all@estgroupe.com')
        
        return redirect():route('topics.index')
    end
    local replies = topic:getRepliesWithLimit(app:conf('lxhub.repliesPerpage'), request.order_by)
    local categoryTopics = topic:getSameCategoryTopics()
    local votedUsers = topic:votes()
        :orderBy('id', 'desc'):with('user')
        :get():col():pluck(function(item)
            return item('user')
        end)
    -- local revisionHistory = topic:revisionHistory():orderBy('created_at', 'desc'):first()
    topic:increment('view_count', 1)
    local cover = topic:cover()
    if topic:isArticle() then
        if request:is('topics*') then
            
            return redirect():to(topic:link())
        end
        user = topic('user')
        blog = topic:blogs():first()
        userTopics = blog:topics():withoutDraft():onlyArticle():orderBy('vote_count', 'desc'):limit(5):get()
        
        c:view('articles.show', Compact('blog', 'user', 'topic', 'replies', 'categoryTopics', 'category', 'banners', 'cover', 'votedUsers', 'userTopics', 'revisionHistory'))
    else 
        userTopics = topic:byWhom(topic.user_id):withoutDraft():withoutBoardTopics():recent():limit(3):get()
        
        c:view('topics.show', Compact('topic', 'replies', 'categoryTopics', 'category', 'banners', 'cover', 'votedUsers', 'userTopics', 'revisionHistory'))
    end
end

function _M:edit(id)

    local topic = Topic.findOrFail(id)
    self:authorize('update', topic)
    local categories = Category.where('id', '!=',Conf('lxhub.blogCategoryId')):get()
    local category = topic.category
    topic.body = topic.body_original
    
    return view('topics.create_edit', Compact('topic', 'categories', 'category'))
end

function _M:append(id, request)

    local topic = Topic.findOrFail(id)
    self:authorize('append', topic)
    local markdown = new('markdown')
    local content = markdown:convertMarkdownToHtml(request:input('content'))
    local append = Append.create({topic_id = topic.id, content = content})
    app('lxhub\\Notification\\Notifier'):newAppendNotify(Auth.user(), topic, append)
    app(UserAddedAppend.class):generate(Auth.user(), topic, append)
    
    return response({status = 200, message = lang('Operation succeeded.'), append = append})
end

function _M:update(id, request, mentionParser)

    local topic = Topic.findOrFail(id)
    self:authorize('update', topic)
    local data = request:only('title', 'body', 'category_id')
    data['body'] = mentionParser:parse(data['body'])
    local markdown = new('markdown')
    data['body_original'] = data['body']
    data['body'] = markdown:convertMarkdownToHtml(data['body'])
    data['excerpt'] = Topic.makeExcerpt(data['body'])
    if topic:isArticle() and request.subject == 'publish' and topic.is_draft == 'yes' then
        data['is_draft'] = 'no'
        -- Topic Published
        app('lxhub\\Notification\\Notifier'):newTopicNotify(Auth.user(), mentionParser, topic)
        -- User activity
        app(UserPublishedNewTopic.class):generate(Auth.user(), topic)
        app(BlogHasNewArticle.class):generate(Auth.user(), topic, topic:blogs():first())
        Auth.user():decrement('draft_count', 1)
        Auth.user():increment('article_count', 1)
    end
    topic:update(data)
    Flash.success(lang('Operation succeeded.'))
    topic:collectImages()
    
    return redirect():to(topic:link())
end

------------------------------------------
-- User Topic Vote function
------------------------------------------

function _M:upvote(id)

    local topic = Topic.find(id)
    app('lxhub\\Vote\\Voter'):topicUpVote(topic)
    
    return response({status = 200})
end

function _M:downvote(id)

    local topic = Topic.find(id)
    app('lxhub\\Vote\\Voter'):topicDownVote(topic)
    
    return response({status = 200})
end

------------------------------------------
-- Admin Topic Management
------------------------------------------

function _M:recommend(id)

    local topic = Topic.findOrFail(id)
    self:authorize('recommend', topic)
    topic.is_excellent = topic.is_excellent == 'yes' and 'no' or 'yes'
    topic:save()
    Notification.notify('topic_mark_excellent', Auth.user(), topic.user, topic)
    
    return response({status = 200, message = lang('Operation succeeded.')})
end

function _M:pin(id)

    local topic = Topic.findOrFail(id)
    self:authorize('pin', topic)
    topic.order = topic.order > 0 and 0 or 999
    topic:save()
    
    return response({status = 200, message = lang('Operation succeeded.')})
end

function _M:sink(id)

    local topic = Topic.findOrFail(id)
    self:authorize('sink', topic)
    topic.order = topic.order >= 0 and -1 or 0
    topic:save()
    app(UserPublishedNewTopic.class):remove(Auth.user(), topic)
    app(BlogHasNewArticle.class):remove(Auth.user(), topic, topic.user:blogs():first())
    
    return response({status = 200, message = lang('Operation succeeded.')})
end

function _M:destroy(id)

    local topic = Topic.findOrFail(id)
    self:authorize('delete', topic)
    topic:delete()
    Flash.success(lang('Operation succeeded.'))
    local blog = topic:blogs():first()
    if topic:isArticle() and topic.is_draft == 'yes' then
        topic:user():decrement('draft_count', 1)
    elseif topic:isArticle() then
        topic:user():decrement('article_count', 1)
        blog:decrement('article_count', 1)
    else 
        topic:user():decrement('topic_count', 1)
    end
    app(UserPublishedNewTopic.class):remove(topic.user, topic)
    app(BlogHasNewArticle.class):remove(topic.user, topic, blog)
    
    return redirect():route('topics.index')
end

function _M:uploadImage(c)

    local file = c.request:file('file')
    if file then
        local upload_status
        try(function()
            upload_status = app('.app.lxhub.handler.imageUploadHandler'):uploadImage(file)
        end)
        :catch('imageUploadException', function(e) 
            
            return {error = e:getMessage()}
        end)
        :run()
        data['filename'] = upload_status['filename']
        SiteStatus.newImage()
    else 
        data['error'] = 'Error while uploading file'
    end
    
    return data
end

------------------------------------------
-- CreatorListener Delegate
------------------------------------------

function _M:creatorFailed(error)

    Flash.error('发布失败：' .. error)
    
    return redirect('/')
end

function _M:creatorSucceed(topic)

    Flash.success(lang('Operation succeeded.'))
    
    return redirect():to(topic:link())
end

return _M

