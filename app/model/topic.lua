
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = 'traits\TopicFilterable, Traits\TopicApiHelper, Traits\TopicImageHelper, RevisionableTrait, SearchableTrait, PresentableTrait, SoftDeletes'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        timestamps = false,
        keepRevisionOf = {'deleted_at', 'is_excellent', 'is_blocked', 'order'},
        searchable = {columns = {['topics.title'] = 10, ['topics.body'] = 5}},
        presenter = 'Phphub\\Presenters\\TopicPresenter',
        dates = {'deleted_at'},
        fillable = {'title', 'slug', 'body', 'excerpt', 'is_draft', 'source', 'body_original', 'user_id', 'category_id', 'created_at', 'updated_at'}
    }
    
    return oo(this, mt)
end

-- manually maintian

-- For admin log
-- Don't forget to fill this table

function _M.s__.boot()

    parent.boot()
    static.created(function(topic)
        SiteStatus.newTopic()
    end)
    static.deleted(function(topic)
        for _, reply in pairs(topic.replies) do
            app(UserRepliedTopic.class):remove(reply.user, reply)
        end
    end)
end

function _M:votes()

    return self:morphMany(Vote.class, 'votable')
end

function _M:attentedUsers()

    return self:belongsToMany(User.class, 'attentions'):get()
end

function _M:votedUsers()

    local user_ids = Vote.where('votable_type', Topic.class):where('votable_id', self.id):where('is', 'upvote'):lists('user_id'):toArray()
    
    return User.whereIn('id', user_ids):get()
end

function _M:Category()

    return self:belongsTo(Category.class)
end

function _M:Tag()

    return self:hasMany(Tag.class)
end

function _M:user()

    return self:belongsTo(User.class)
end

function _M:lastReplyUser()

    return self:belongsTo(User.class, 'last_reply_user_id')
end

function _M:replies()

    return self:hasMany(Reply.class)
end

function _M:blogs()

    return self:belongsToMany(Blog.class, 'blog_topics')
end

function _M:appends()

    return self:hasMany(Append.class)
end

function _M:generateLastReplyUserInfo()

    local lastReply = self:replies():recent():first()
    self.last_reply_user_id = lastReply and lastReply.user_id or 0
    self:save()
end

function _M:getRepliesWithLimit(limit, order)

    order = order or 'created_at'
    limit = limit or 30
    local pageName = 'page'
    -- Default display the latest reply
    local latest_page = not \Input.get(pageName) and ceil(self.reply_count / limit) or 1
    local query = self:replies():with('user')
    query = order == 'vote_count' and query:orderBy('vote_count', 'desc') or query:orderBy('created_at', 'asc')
    
    return query:paginate(limit, {'*'}, pageName, latest_page)
end

function _M:getSameCategoryTopics()

    local data = Cache.remember('phphub_hot_topics_' .. self.category_id, 30, function()
        
        return Topic.where('category_id', '=', self.category_id):recent():with('user'):take(3):get()
    end)
    
    return data
end

function _M.s__.makeExcerpt(body)

    local html = body
    local excerpt = str.trim(str.rereplace(strip_tags(html), '/\\s\\s+/', ' '))
    
    return str.limit(excerpt, 200)
end

function _M:setTitleAttribute(value)

    self.attributes['title'] = (new('autoCorrect')):convert(value)
end

function _M:scopeByWhom(query, user_id)

    return query:where('user_id', '=', user_id)
end

function _M:scopeDraft(query)

    return query:where('is_draft', '=', 'yes')
end

function _M:scopeWithoutDraft(query)

    return query:where('is_draft', '=', 'no')
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

function _M:getRandomExcellent()

    local data = Cache.remember('phphub_random_topics', 10, function()
        topic = new('topic')
        
        return topic:getTopicsWithFilter('random-excellent', 5)
    end)
    
    return data
end

function _M:isArticle()

    return self.category_id == config('phphub.blog_category_id')
end

function _M:link(params)

    params = params or {}
    params = tb.merge({self.id, self.slug}, params)
    local name = self:isArticle() and 'articles.show' or 'topics.show'
    
    return str.replace(route(name, params), env('API_DOMAIN'), env('APP_DOMAIN'))
end

return _M

