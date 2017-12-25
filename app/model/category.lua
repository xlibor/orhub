
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = {
        -- 'revisionableMix',
        'softDelete'
    }
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self.keepRevisionOf = {'deleted_at'}
end

-- For admin log
function _M:topics(filter)

    return self:hasMany('Topic'):getTopicsWithFilter(filter)
end

function _M:scopeTopicAttachable(query)

    return query
        :where('id', '!=', app:conf('lxhub.blogCategoryId'))
        :where('id', '!=', app:conf('lxhub.googleGroupsCategoryId'))
end

return _M

