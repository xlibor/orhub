
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = {
        '.app.model.mix.topicFilterable',
        '.app.model.mix.topicApiHelper',
        '.app.model.mix.topicImageHelper',
        -- 'revisionableMix',
        'searchableMix',
        'presentableMix',
        'softDelete',
        'tagging.taggable',
    },
    _static_ = {}
}

local app, lf, tb, str  = lx.kit()
local route             = lx.h.route
local env               = lx.env
local SiteStatus        = lx.use('.app.model.siteStatus')
local UserRepliedTopic  = lx.use('.app.activity.userRepliedTopic')

local static

function _M._init_(this)

    static = this.static
end

function _M:ctor()

    self.table = 'topics'
    self.timestamps = false
    self.keepRevisionOf = {
        'deleted_at', 'is_excellent', 'is_blocked', 'order'
    }
    self.searchable = {
        columns = {
            ['topics.title'] = 10, ['topics.body'] = 5
        }
    }
    self.presenter = '.app.core.presenter.topic'
    self.dates = {'deleted_at'}
    self.fillable = {
        'title', 'slug', 'body', 'excerpt', 'is_draft', 'source',
        'body_original', 'user_id', 'category_id', 'created_at',
        'updated_at', 'summary', 'is_tagged', 'extra'
    }
end

function _M:boot()

    self:__super(_M, 'boot')
    self:created(function(topic)

        SiteStatus.newTopic()
    end)
    self:deleted(function(topic)
        for _, reply in ipairs(topic('replies')) do
            new(UserRepliedTopic):remove(reply('user'), reply)
        end
    end)
end

function _M:votes()

    return self:morphMany(Vote, 'votable')
end

function _M:attentedUsers()

    return self:belongsToMany(User, 'attentions'):get()
end

function _M:votedUsers()

    local user_ids = Vote.where('votable_type', '.app.model.topic'):where('votable_id', self.id):where('is', 'upvote'):pluck('user_id')
    
    return User.whereIn('id', user_ids):get()
end

function _M:category()

    return self:belongsTo(Category)
end

function _M:user()

    return self:belongsTo(User)
end

function _M:lastReplyUser()

    return self:belongsTo(User, 'last_reply_user_id')
end

function _M:replies()

    return self:hasMany(Reply)
end

function _M:blogs()

    return self:belongsToMany(Blog, 'blog_topics')
end

function _M:appendContents()

    return self:hasMany(Append)
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
    local latest_page = not Req.get(pageName) and math.ceil(self.reply_count / limit) or 1
    local query = self:replies():with('user')
    query = order == 'vote_count' and query:orderBy('vote_count', 'desc') or query:orderBy('created_at', 'asc')
    
    return query:paginate(limit, {'*'}, pageName, latest_page)
end

function _M:getSameCategoryTopics()

    local data = Cache.remember('lxhub_hot_topics_' .. self.category_id, 30, function()
        
        return Topic.where('category_id', '=', self.category_id):recent():with('user'):take(3):get()
    end)
    
    return data
end

function _M.s__.makeExcerpt(body)

    local html = body

    local excerpt = str.trim(str.rereplace(str.stripTags(html), [[\s\s+]], ' '))
    
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

    local data = Cache.remember('lxhub_random_topics', 10, function()
        topic = new('topic')
        
        return topic:getTopicsWithFilter('random-excellent', 5)
    end)
    
    return data
end

function _M:isArticle()

    return self.category_id == app:conf('lxhub.blogCategoryId')
end

function _M:link(params)

    params = params or {}
    params = tb.merge({self.id, self.slug}, params)
    local name = self:isArticle() and 'articles.show' or 'topics.show'

    return str.replace(route(name, params), env('apiDomain'), env('apiDomain'))
end

return _M

