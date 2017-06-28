
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        topic_count = nil,
        reply_count = nil,
        user_count = nil
    }
    
    return oo(this, mt)
end
return _M

