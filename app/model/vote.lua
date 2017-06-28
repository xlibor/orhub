
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.fillable = {'user_id', 'votable_id', 'votable_type', 'is'}

end

function _M:votable()

    return self:morphTo()
end

function _M:user()

    return self:belongsTo(User.class)
end

function _M:scopeByWhom(query, user_id)

    return query:where('user_id', '=', user_id)
end

function _M:scopeWithType(query, type)

    return query:where('is', '=', type)
end

return _M

