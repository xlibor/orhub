
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'presenter'
}

local app, lf, tb, str, new = lx.kit()
local Markdown = lx.use('.app.core.markdown.markdown')
local slen = string.len

-- Present a link to the user gravatar.

function _M:gravatar(size)

    size = size or 100
    local postfix
    if app:conf('app.urlStatic') and slen(self.avatar) > 0 then
        --Using Qiniu image processing service.
        postfix = size > 0 and '?imageView2/1/w/' .. size .. '/h/' .. size or ''
        
        return Ah.cdn('/uploads/avatars/' .. self.avatar) .. postfix
    end
    local github_id = self.github_id
    local domainNumber = lf.rand(0, 3)
    
    return fmt(
        "https://avatars%s.githubusercontent.com/u/%s?v=2&s=%s"
        , domainNumber, github_id, size
    )
end

function _M:loginQR(size)

    size = size or 80
    if not self.login_token then
        self.entity.login_token = str.random(20)
        self.entity:save()
    end
    return ''
    -- return QrCode.format('png'):size(200):errorCorrection('L'):margin(0):encoding('utf-8'):generate(self.id .. ',' .. self.login_token)
end

function _M:userinfoNavActive(anchor)

    return Route.currentRouteName() == anchor and 'active' or ''
end

function _M:hasBadge()

    local relations = Role.relationArrayWithCache()
    local user_ids = tb.pluck(relations, 'user_id')
    
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
    relations = tb.sortBy(relations, 'role_id')
    local relation = tb.first(relations, function(value, key)

        return value.user_id == self.id
    end)
    if not relation then
        
        return false
    end
    local roles = Role.rolesArrayWithCache()
    local role = tb.first(roles, function(value, key)
        
        return value.id == relation.role_id
    end)
    
    return role
end

function _M:isAdmin()

    local relations = Role.relationArrayWithCache()
    relations = tb.where(relations, function(key, value)
        
        return value.user_id == self.id and value.role_id <= 2
    end)
    
    return #relations
end

function _M:followingUsersJson()

    local users = Auth.user():followings():pluck('name')
    
    return lf.jsen(users)
end

function _M:lastActivedAt()

    local show_key =Conf('orhub.actived_time_data')
    local show_data = Cache.get(show_key)
    if not show_data[self.id] then
        show_data[self.id] = self.last_actived_at
        Cache.forever(show_key, show_data)
    end
    
    return show_data[self.id]
end

function _M:formattedSignature()

    return new(Markdown):convertMarkdownToHtml(self.signature)
end

return _M

