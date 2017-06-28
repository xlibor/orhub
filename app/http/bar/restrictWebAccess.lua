
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:handle(request, next)

    -- 如果是通过 API 域名进来的话，就拒绝访问
    -- 这样做是为了防止网站出现双入口，混淆用户和 SEO 优化。
    if is_request_from_api() then
        
        return response('Bad Request.', 400)
    end
    
    return next(request)
end

return _M

