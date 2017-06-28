
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:home(topic, request)

    if Auth.check() then
        
        return app(ActivityController.class):index(request)
    else 
        topics = topic:getTopicsWithFilter('excellent')
        banners = Banner.allByPosition()
        
        return view('pages.home', compact('topics', 'banners'))
    end
end

function _M:about()

    return view('pages.about')
end

function _M:composer(request)

    return app(TopicsController.class):show(4484, request, true)
end

function _M:wildcard(name, request)

    return app(BlogsController.class):show(name)
end

function _M:wiki(request)

    return app(TopicsController.class):show(config('phphub.wiki_topic_id'), request, true)
end

function _M:search(request)

    local users
    local topics
    local user
    local query = Purifier.clean(request:input('q'), 'search_q')
    if request.user_id then
        user = User.findOrFail(request.user_id)
        topics = Topic.search(query, nil, true):withoutBlocked():withoutBoardTopics():withoutDraft():byWhom(user.id):paginate(30)
        users = collect({})
    end
    local filterd_noresult = topics and topics:total() == 0 or false
    if not request.user_id or request.user_id and topics:total() == 0 then
        user = request.user_id and user or new('user')
        users = User.search(query, nil, true):orderBy('last_actived_at', 'desc'):limit(5):get()
        topics = Topic.search(query, nil, true):withoutBlocked():withoutBoardTopics():withoutDraft():paginate(30)
    end
    
    return view('pages.search', compact('users', 'user', 'query', 'topics', 'filterd_noresult'))
end

function _M:feed()

    local topics = Topic.excellent():recent():limit(20):get()
    local channel = {title = 'Laravel China 社区', description = '我们是 PHP 和 Laravel 的中文社区，在这里我们讨论技术, 分享技术。', link = url(route('feed'))}
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

    return app('Phphub\\Sitemap\\Builder'):render()
end

function _M:hallOfFames()

    local users = User.byRolesName('HallOfFame')
    
    return view('pages.hall_of_fame', compact('users'))
end

return _M

