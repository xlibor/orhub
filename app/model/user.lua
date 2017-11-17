
local lx, _M = oo{
    _cls_   = '',
    _ext_   = 'model',
    -- _bond_  = {'authenticatableBond', 'authorizableBond'},
    _mix_   = {
        '.app.model.mix.userRememberTokenHelper',
        '.app.model.mix.userSocialiteHelper',
        '.app.model.mix.userAvatarHelper',
        '.app.model.mix.userActivityHelper',
        'presentableMix',
        'entrustUserMix',
        '.app.model.mix.followHelper',
        'messenger.messagable',
        'searchableMix',
        -- 'revisionableMix',
        'softDelete'
    },
    _static_ = {}
}

local app, lf, tb, str = lx.kit()
local Attention = lx.use('.app.model.attention')

function _M:ctor()

    self.presenter = '.app.core.presenter.user'
    self.searchable = {
        columns = {
            ['users.name'] = 10, ['users.real_name'] = 10,
            ['users.introduction'] = 10
        }
    }
    self.keepRevisionOf = {'is_banned'}
    self.dates = {'deleted_at'}
    self.table = 'users'
    self.guarded = {'id', 'is_banned'}
end

-- For admin log
function _M:boot()

    self:__super(_M, 'boot')
    -- static.created(function(user)
    --     driver = user['github_id'] and 'github' or 'wechat'
    --     SiteStatus.newUser(driver)
    --     dispatch(new('sendActivateMail', user))
    -- end)
    -- static.deleted(function(user)
    --     \Artisan.call('lxhub:clear-user-data', {user_id = user.id})
    -- end)
end

function _M:scopeIsRole(query, role)

    return query:whereHas('roles', function(query)
        query:where('name', role)
    end)
end

function _M.s__.byRolesName(name)

    local data = Cache.remember('lxhub_roles_' .. name, 60, function()
        
        return User.isRole(name):orderBy('last_actived_at', 'desc'):get()
    end)
    
    return data
end

function _M:managedBlogs()

    return self:belongsToMany(Blog, 'blog_managers')
end

-- For EntrustUserTrait and SoftDeletes conflict

function _M:restore()

    self:restoreEntrust()
    self:restoreSoftDelete()
end

function _M:votedTopics()

    return self:morphedByMany(Topic, 'votable', 'votes'):withPivot('created_at')
end

function _M:topics()

    return self:hasMany(Topic)
end

function _M:blogs()

    return self:hasMany(Blog)
end

function _M:replies()

    return self:hasMany(Reply)
end

function _M:subscribes()

    return self:belongsToMany(Blog, 'blog_subscribers')
end

function _M:attentTopics()

    return self:belongsToMany(Topic, 'attentions'):withTimestamps()
end

function _M:notifications()

    return self:hasMany(Notification):recent():with('topic', 'fromUser'):paginate(20)
end

function _M:revisions()

    return self:hasMany(Revision)
end

function _M:scopeRecent(query)

    return query:orderBy('created_at', 'desc')
end

function _M:getIntroductionAttribute(value)

    return str.limit(value, 68)
end

function _M:getPersonalWebsiteAttribute(value)

    return str.replace(value, {'https://', 'http://'}, '')
end

function _M:isAttentedTopic(topic)

    return Attention.isUserAttentedTopic(self, topic)
end

function _M:subscribe(blog)

    return blog:subscribers():where('user_id', self.id):count() > 0
end

function _M:isAuthorOf(model)

    return self.id == model.user_id
end

------------------------------------------
-- UserInterface
------------------------------------------

function _M:getAuthIdentifier()

    return self:getKey()
end

function _M:getAuthPassword()

    return self.password
end

function _M:recordLastActivedAt()

    local now = Carbon.now():toDateTimeString()
    local update_key = app:conf('lxhub.activedTimeForUpdate')
    local update_data = Cache.get(update_key)
    update_data[self.id] = now
    Cache.forever(update_key, update_data)
    local show_key =Conf('lxhub.actived_time_data')
    local show_data = Cache.get(show_key)
    show_data[self.id] = now
    Cache.forever(show_key, show_data)
end

return _M

