
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()
local route = lx.h.route

function _M:new()

    local this = {
        body_parsed = nil,
        users = {},
        usernames = nil,
        body_original = nil
    }
    
    return oo(this, mt)
end

function _M:getMentionedUsername()

    local atlist_tmp = str.rematchAll(
        self.body_original, [[(\S*)\@([^\r\n\s]*)]], 'ijo'
    )

    local usernames = {}
    if atlist_tmp then

        for _, m in ipairs(atlist_tmp) do
            if m[1] == '' and str.len(m[2]) <= 25 then
                tapd(usernames, m[2])
            end
        end
    end
    
    return tb.unique(usernames)
end

function _M:replace()

    local place
    local search
    self.body_parsed = self.body_original
    for _, user in pairs(self.users) do
        search = '@' .. user.name
        place = '[' .. search .. '](' .. route('users.show', user.id) .. ')'
        self.body_parsed = str.replace(self.body_parsed, search, place)
    end
end

function _M:parse(body)

    self.body_original = body
    self.usernames = self:getMentionedUsername()
    if #self.usernames > 0 then
        self.users = User.whereIn('name', self.usernames):get()
    end
    self:replace()
    
    return self.body_parsed
end

return _M

