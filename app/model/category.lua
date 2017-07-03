
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

return _M

