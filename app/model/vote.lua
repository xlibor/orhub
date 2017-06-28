
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        fillable = {'user_id', 'votable_id', 'votable_type', 'is'}
    }
    
    return oo(this, mt)
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

