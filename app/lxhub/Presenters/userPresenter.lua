
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'presenter'
}

local app, lf, tb, str = lx.kit()

-- Present a link to the user gravatar.

function _M:gravatar(size)

    size = size or 100
    local postfix
    if config('app.url_static') and self.avatar then
        --Using Qiniu image processing service.
        postfix = size > 0 and "?imageView2/1/w/{size}/h/{size}" or ''
        
        return cdn('uploads/avatars/' .. self.avatar) .. postfix
    end
    local github_id = self.github_id
    local domainNumber = rand(0, 3)
    
    return "https://avatars{domainNumber}.githubusercontent.com/u/{github_id}?v=2&s={size}"
end

function _M:loginQR(size)

    size = size or 80
    if not self.login_token then
        self.entity.login_token = str.random(20)
        self.entity:save()
    end
    
    return \QrCode.format('png'):size(200):errorCorrection('L'):margin(0):encoding('utf-8'):generate(self.id .. ',' .. self.login_token)
end

function _M:userinfoNavActive(anchor)

    return Route.currentRouteName() == anchor and 'active' or ''
end

function _M:hasBadge()

    local relations = Role.relationArrayWithCache()
    local user_ids = array_pluck(relations, 'user_id')
    
    return tb.inList(user_ids, self.id)
end

function _M:badgeID()

    local role = self:getBadge()
    if not role then
        
        return
    end
    
    return role.id
end

function _M:badgeName()

    local role = self:getBadge()
    if not role then
        
        return
    end
    
    return role.display_name
end

function _M:getBadge()

    local relations = Role.relationArrayWithCache()
    -- 用户所在的用户组，显示 role_id 最小的名称
    relations = array_sort(relations, function(value)
        
        return value.role_id
    end)
    local relation = array_first(relations, function(key, value)
        
        return value.user_id == self.id
    end)
    if not relation then
        
        return false
    end
    local roles = Role.rolesArrayWithCache()
    local role = array_first(roles, function(key, value)
        
        return value.id == relation.role_id
    end)
    
    return role
end

function _M:isAdmin()

    local relations = Role.relationArrayWithCache()
    relations = array_where(relations, function(key, value)
        
        return value.user_id == self.id and value.role_id <= 2
    end)
    
    return #relations
end

function _M:followingUsersJson()

    local users = \Auth.user():followings():lists('name')
    
    return lf.jsen(users)
end

function _M:lastActivedAt()

    local show_key = config('phphub.actived_time_data')
    local show_data = Cache.get(show_key)
    if not show_data[self.id] then
        show_data[self.id] = self.last_actived_at
        Cache.forever(show_key, show_data)
    end
    
    return show_data[self.id]
end

function _M:formattedSignature()

    return (new('markdown')):convertMarkdownToHtml(self.signature)
end

return _M

