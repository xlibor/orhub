
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:getTopicsWithFilter(filter, limit)

    limit = limit or 20
    filter = self:getTopicFilter(filter)

    return self:applyFilter(filter):with('user', 'category', 'lastReplyUser'):paginate(limit)
end

function _M:getCategoryTopicsWithFilter(filter, category_id, limit)

    limit = limit or 20
    
    return self:applyFilter(filter == 'default' and 'category' or filter):where('category_id', '=', category_id):with('user', 'category', 'lastReplyUser'):paginate(limit)
end

function _M:getTopicFilter(request_filter)

    local filters = {'noreply', 'vote', 'excellent', 'recent', 'wiki', 'jobs', 'excellent-pinned', 'index'}
    if tb.inList(filters, request_filter) then
        
        return request_filter
    end
    
    return 'default'
end

function _M:applyFilter(filter)

    local query = self:withoutBlocked():withoutDraft()
    -- 过滤站务信息
    query = query:withoutBoardTopics()
    local st = filter
    if st == 'noreply' then
        
        return query:pinned():orderBy('reply_count', 'asc'):recent()
    elseif st == 'vote' then
        
        return query:pinned():orderBy('vote_count', 'desc'):recent()
    elseif st == 'excellent' then
        
        return query:excellent():recent()
        -- 主要 API 首页在用，置顶+精华
    elseif st == 'excellent-pinned' then
        
        return query:excellent():pinned():recent()
    elseif st == 'random-excellent' then
        
        return query:excellent():fresh():random()
    elseif st == 'recent' then
        
        return query:pinned():recent()
    elseif st == 'category' then
        
        return query:pinned():recentReply()
        -- for api，分类：教程
    elseif st == 'wiki' then
        
        return query:where('category_id', 6):pinned():recent()
        -- for api，分类：招聘
    elseif st == 'jobs' then
        
        return query:where('category_id', 1):pinned():recent()
    elseif st == 'index' then
        -- return query:excellent():recent()
        return query:pinAndRecentReply():withoutQA():recent()
    else 
        
        return query:pinAndRecentReply()
    end
end

function _M:scopeWhose(query, user_id)

    return query:where('user_id', '=', user_id):with('category')
end

function _M:scopeOnlyArticle(query)

    return query:where('category_id', '=', app:conf('lxhub.blogCategoryId'))
end

function _M:scopeWithoutArticle(query)

    return query:where('category_id', '!=', app:conf('lxhub.blogCategoryId'))
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

function _M:scopeRandom(query)

    return query:orderByRaw("RAND()")
end

function _M:scopePinAndRecentReply(query)

    return query:fresh():pinned():orderBy('updated_at', 'desc')
end

function _M:scopePinned(query)

    return query:orderBy('order', 'desc')
end

function _M:scopeFresh(query)

    return query:whereRaw("(`created_at` > '" .. Dt.today():subMonths(3):toDateString() .. "' or (`order` > 0) )")
end

function _M:scopeRecentReply(query)

    return query:pinned():orderBy('updated_at', 'desc')
end

function _M:scopeExcellent(query)

    return query:where('is_excellent', '=', 'yes')
end

function _M:scopeWithoutBlocked(query)

    return query:where('is_blocked', '=', 'no')
end

function _M:scopeWithoutBoardTopics(query)

    if app:conf('lxhub.adminBoardCid') and (not Auth.check() or not Auth.user():can('access_board')) then
        
        return query:where('category_id', '!=', app:conf('lxhub.adminBoardCid'))
    end
    
    return query
end

function _M:scopeWithoutQA(query)

    if app:conf('lxhub.qaCategoryId') then

        return query:where('category_id', '!=', app:conf('lxhub.qaCategoryId'))
    end
    
    return query
end

function _M:correctApiFilter(filter)

    local st = filter
    if st == 'newest' then
        
        return 'recent'
    elseif st == 'excellent' then
        
        return 'excellent-pinned'
    elseif st == 'nobody' then
        
        return 'noreply'
    else 
        
        return filter
    end
end

return _M

