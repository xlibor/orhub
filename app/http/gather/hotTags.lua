
local lx, _M = oo{
    _cls_ = ''
}

local app, lf, tb, str, new = lx.kit()

local Tag = lx.use('.app.model.tag')

function _M:ctor()

end

function _M:gather(context, view)

    local tags = new(Tag):hotTags(13):get()

    context.hotTags = tags
end

return _M

