
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseTransformer'
}

local app, lf, tb, str = lx.kit()

function _M:transformData(model)

    return {
        ['"id"'] = model.id,
        ['"description"'] = model.description,
        ['"image_small"'] = model.image_small,
        ['"image_large"'] = model.image_large,
        ['"type"'] = model.type,
        ['"payload"'] = model.payload,
        ['"display_time"'] = model.display_time,
        ['"start_at"'] = model.start_at,
        ['"expires_at"'] = model.expires_at
    }
end

return _M

