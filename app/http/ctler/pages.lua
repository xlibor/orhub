
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str, new = lx.kit()

local use = lx.ns('.app.http.ctler')
local ActivityCtler, TopicsCtler, BlogsCtler = use('activity', 'topics', 'blogs')

function _M:home(c)
    
    local request = c.req
    local topics = new(Topic):getTopicsWithFilter('excellent')
    c:view('pages.home', Compact('topics', 'banners'))
end

function _M:about(c)

    c:view('pages.about')
end

function _M:composer(c)

    return new(TopicsCtler):show(c, 4484, true)
end

function _M:wildcard(c, name)

    return new(BlogsCtler):show(c, name)
end

function _M:wiki(c)

    return new(TopicsCtler):show(c, app:conf('orhub.wikiTopicId'), true)
end

function _M:search(c)

    local request = c.req
    local user, users, topics
    local query = request:input('q')
    if request.user_id then
        user = User.findOrFail(request.user_id)
        topics = Topic.search(query, nil, true):withoutBlocked():withoutBoardTopics():withoutDraft():byWhom(user.id):paginate(30)
        users = {}
    end
    
    local filterd_noresult = topics and topics:total() == 0 or false
    if not request.user_id or (request.user_id and topics:total() == 0) then
        user = request.user_id and user or new(User)
        if not user.id then user.id = 0 end
        users = User.search(query, nil, true):orderBy('last_actived_at', 'desc'):limit(5):get()
        topics = Topic.search(query, nil, true):withoutBlocked():withoutBoardTopics():withoutDraft():paginate(30)
    end
    
    return c:view('pages.search', Compact('users', 'user', 'query', 'topics', 'filterd_noresult'))
end

function _M:feed()

    local topics = Topic.excellent():recent():limit(20):get()
    local channel = {title = 'orhub 社区', description = '我们是 openresty 和 lua 的中文社区，在这里我们讨论技术, 分享技术。', link = url(route('feed'))}
    local feed = Rss.feed('2.0', 'UTF-8')
    feed:channel(channel)
    for _, topic in pairs(topics) do
        feed:item({
            title = topic.title,
            ['description|cdata'] = str.limit(topic.body, 200),
            link = topic:link(),
            pubDate = date('Y-m-d', strtotime(topic.created_at))
        })
    end
    
    return response(feed, 200, {['Content-Type'] = 'text/xml'})
end

function _M:sitemap()

    return app('orhub\\Sitemap\\Builder'):render()
end

function _M:hallOfFames()

    local users = User.byRolesName('HallOfFame')
    
    return view('pages.hall_of_fame', Compact('users'))
end

return _M

