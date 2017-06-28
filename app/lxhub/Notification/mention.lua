
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

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

    preg_match_all("/(\\S*)\\@([^\r\n\\s]*)/i", self.body_original, atlist_tmp)
    local usernames = {}
    for k, v in pairs(atlist_tmp[2]) do
        if atlist_tmp[1][k] or str.len(v) > 25 then
            continue
        end
        tapd(usernames, v)
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
    #self.usernames > 0 and (self.users = User.whereIn('name', self.usernames):get())
    self:replace()
    
    return self.body_parsed
end

return _M

