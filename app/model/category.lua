
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'model',
    _mix_ = 'revisionableTrait, SoftDeletes'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        keepRevisionOf = {'deleted_at'},
        fillable = {}
    }
    
    return oo(this, mt)
end

-- For admin log
function _M:topics(filter)

    return self:hasMany('Topic'):getTopicsWithFilter(filter)
end

return _M

