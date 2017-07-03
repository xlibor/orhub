
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:index(request)

    local st = request.view
    if st == 'all' then
        activities = Activity.recent():paginate(50)
    elseif st == 'mine' then
        activities = Auth().user:activities()
    else 
        activities = Auth().user:subscribedActivityFeeds()
    end
    local links = Link.allFromCache()
    local banners = Banner.allByPosition()
    local active_users = ActiveUser.fetchAll()
    local hot_topics = HotTopic.fetchAll()
    local images = Image.fromActivities(activities)
    
    return view('activities.index', Compact('activities', 'links', 'banners', 'active_users', 'hot_topics', 'images'))
end

return _M

