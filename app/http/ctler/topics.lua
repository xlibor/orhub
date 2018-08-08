
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller',
    -- _bond_ = 'creatorListener',
}

local app, lf, tb, str, new = lx.kit()
local use, try, lh, fs      = lx.use, lx.try, lx.h, lx.fs
local redirect              = lh.redirect
local lang                  = Ah.lang

local Class                 = use('class')
local Topic                 = use('.app.model.topic')
local Tag                   = use('.app.model.tag')
local Markdown              = use('.app.core.markdown.markdown')
local Notifier              = use('.app.core.notification.notifier')
local MentionParser         = use('.app.core.notification.mention')
local UserPublishedNewTopic = use('.app.activity.userPublishedNewTopic')
local UserAddedAppend       = use('.app.activity.userAddedAppend')
local BlogHasNewArticle     = use('.app.activity.blogHasNewArticle')
local Notification          = use('.app.model.notification')
local SiteStatus            = use('.app.model.siteStatus')
local TopicDoer             = use('.app.http.doer.topic')

local ssub, sfind = string.sub, string.find
local e = lh.e

function _M:ctor()

    self:setBar('auth', {except = {'index', 'show'}})
end

function _M:index(c)

    local request = c.req

    local topics = new(Topic):getTopicsWithFilter(request:get('filter', 'index'), 40)

    local links = Link.allFromCache()
    local active_users = ActiveUser.fetchAll()
    local hot_topics = HotTopic.fetchAll()

    c:view('topics.index', {
        topics = topics, links = links, banners = banners,
        active_users = active_users, hot_topics = hot_topics
    })
end

function _M:show(c, id, fromCode)

    local request = c.req

    fromCode = fromCode or false
    local userTopics, blog, user
    local topic = Topic.where('id', id):with('user', 'lastReplyUser'):firstOrFail()
    if topic:isArticle() and topic.is_draft == 'yes' then
        self:authorize('show_draft', topic)
    end
 
    local slug = request:param('slug')

    if not lf.isEmpty(topic.slug) and topic.slug ~= slug and not fromCode then
        
        return redirect(topic:link(), 301)
    end
    if topic('user').is_banned == 'yes' then
        if not Auth.check() or Auth.check() and not Auth.user():may('manage_topics') then
            Flash.error('Äã·ÃÎÊµÄÎÄÕÂÒÑ±»ÆÁ±Î£¬ÓÐÒÉÎÊÇë·¢ÓÊ¼þ£ºall@estgroupe.com')
            
            return redirect(route('topics.index'))
        end
        Flash.error('µ±Ç°ÎÄÕÂµÄ×÷ÕßÒÑ±»ÆÁ±Î£¬ÓÎ¿ÍÓëÓÃ»§½«¿´²»µ½´ËÎÄÕÂ¡£')
    end
    if Conf('orhub.adminBoardCid') and topic.id == Conf('orhub.adminBoardCid') and (not Auth.check() or not Auth.user():can('access_board')) then
        Flash.error('ÄúÃ»ÓÐÈ¨ÏÞ·ÃÎÊ¸ÃÎÄÕÂ£¬ÓÐÒÉÎÊÇë·¢ÓÊ¼þ£ºall@estgroupe.com')
        
        return redirect():route('topics.index')
    end
    local replies = topic:getRepliesWithLimit(app:conf('orhub.repliesPerpage'), request.order_by)
    local votedUsers = topic:votes()
        :orderBy('id', 'desc'):with('user')
        :get():col():pluck(function(item)
            return item('user')
        end)
    -- local revisionHistory = topic:revisionHistory():orderBy('created_at', 'desc'):first()
    topic:increment('view_count', 1)
    local cover = topic:cover() or false

    local tags = false
    if topic.is_tagged == 'yes' then
        tags = topic('tags')
    end

    if topic:isArticle() then
        if request:is('topics*') then
            return redirect():to(topic:link())
        end
        user = topic('user')
        blog = topic:blogs():first()

        c:view('articles.show', {
            blog = blog, user = user, topic = topic,
            replies = replies, category = category,
            tags = tags, banners = banners, cover = cover,
            votedUsers = votedUsers, revisionHistory = revisionHistory
        })
    else
        local appends = topic:appendContents():get()

        c:view('topics.show', {
            topic = topic, replies = replies, category = category,
            tags = tags, banners = banners, cover = cover,
            votedUsers = votedUsers, revisionHistory = revisionHistory,
            appends = appends
        })
    end
end

function _M:create(c)

    local request = c.req
    local categoryId = request:input('category_id')
    local category
    if categoryId then
        category = Category.find(categoryId)
    end
    local categories = new(Category):topicAttachable():get()
    local tags = Tag.all()
    local topicTags = false

    return c:view('topics.create_edit', {
        categories = categories, tags = tags,
        topicTags = topicTags, category = category
    })
end

function _M:store(c)

    local request = c:form('storeTopicRequest')

    return new(TopicDoer):create(self, Auth.user(), request:except('_token'), true)
end

function _M:edit(c, id)

    local topic = Topic.findOrFail(id)
    self:authorize('update', topic)
    topic.body = topic.body_original
    local categories = Category.where('id', '!=', Conf('orhub.blogCategoryId')):get()
    local category = topic('category')
    local tags = Tag.all()
    local topicTags = tb.flip(topic:tagNames(), true)
    
    return c:view('topics.create_edit', {
        topic = topic, categories = categories, tags = tags,
        topicTags = topicTags, category = category
    })
end

function _M:append(c, id)
    
    local request = c.req
    local topic = Topic.findOrFail(id)
    self:authorize('append', topic)
    local markdown = new(Markdown)
    local content = markdown:convertMarkdownToHtml(request:input('content'))
    local append = Append.create({topic_id = topic.id, content = content})
    app(Notifier):newAppendNotify(Auth.user(), topic, append)
    app(UserAddedAppend):generate(Auth.user(), topic, append)
    
    return c:json({status = 200, message = lang('Operation succeeded.'), append = append:toArr()})
end

function _M:update(c, id)

    local request = c:form('storeTopicRequest')

    local topic = Topic.findOrFail(id)
    self:authorize('update', topic)
    local data = request:only('title', 'body', 'category_id', 'tags')

    return new(TopicDoer):update(self, Auth.user(), data, topic, request:input('subject'))
end

------------------------------------------
-- User Topic Vote function
------------------------------------------

function _M:upvote(c, id)

    local topic = Topic.find(id)
    app('.app.core.vote.voter'):topicUpVote(topic)
    
    return c:json({status = 200})
end

function _M:downvote(c, id)

    local topic = Topic.find(id)
    app('orhub\\Vote\\Voter'):topicDownVote(topic)
    
    return response({status = 200})
end

------------------------------------------
-- Admin Topic Management
------------------------------------------

function _M:recommend(c, id)

    local topic = Topic.findOrFail(id)
    self:authorize('recommend', topic)
    topic.is_excellent = topic.is_excellent == 'yes' and 'no' or 'yes'
    topic:save()
    Notification.notify('topic_mark_excellent', Auth.user(), topic('user'), topic)
    
    return c:json{status = 200, message = lang('Operation succeeded.')}
end

function _M:pin(c, id)

    local topic = Topic.findOrFail(id)
    self:authorize('pin', topic)
    topic.order = topic.order > 0 and 0 or 999
    topic:save()
    
    return c:json{status = 200, message = lang('Operation succeeded.')}
end

function _M:sink(c, id)

    local topic = Topic.findOrFail(id)
    self:authorize('sink', topic)
    topic.order = topic.order >= 0 and -1 or 0
    topic:save()
    app(UserPublishedNewTopic):remove(Auth.user(), topic)
    app(BlogHasNewArticle):remove(Auth.user(), topic, topic('user'):blogs():first())
    
    return c:json{status = 200, message = lang('Operation succeeded.')}
end

function _M:destroy(c, id)

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
    app(UserPublishedNewTopic):remove(topic('user'), topic)
    app(BlogHasNewArticle):remove(topic('user'), topic, blog)
    
    return redirect():route('topics.index')
end

function _M:uploadImage(c)

    local file = c.req:file('file')
    local data = {}
    if file then
        local upload_status
        try(function()
            upload_status = app('.app.core.handler.imageUploadHandler'):uploadImage(file)
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

    Flash.error('create topic failed' .. error)
    
    return redirect('/')
end

function _M:creatorSucceed(topic)

    Flash.success(lang('Operation succeeded.'))
    
    return redirect():to(topic:link())
end

return _M

