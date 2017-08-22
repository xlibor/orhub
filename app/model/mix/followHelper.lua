
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

-- Follow a user or users.
-- @param int|array user
-- @return int

function _M:follow(user)

    return self:followings():sync(lf.needList(user), false)
end

-- Unfollow a user or users.
-- @param int|array user
-- @return int

function _M:unfollow(user)

    return self:followings():detach(lf.needList(user))
end

-- Check if user is following given user.
-- @param user
-- @return bool

function _M:isFollowing(user)

    return self('followings'):col():contains(user)
end

-- Check if user is followed by given user.
-- @param user
-- @return bool

function _M:isFollowedBy(user)

    return self.followers:contains(user)
end

-- Return user followers.
-- @return belongsToMany

function _M:followers()

    return self:belongsToMany(self, 'followers', 'follow_id', 'user_id')
end

-- Return user following users.
-- @return belongsToMany

function _M:followings()

    return self:belongsToMany(self, 'followers', 'user_id', 'follow_id')
end

return _M

