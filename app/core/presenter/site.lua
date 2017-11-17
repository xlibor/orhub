
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'presenter'
}

local app, lf, tb, str = lx.kit()

function _M:linkWithUTMSource()

    local append = 'utm_source=laravel-china.org'
    
    return str.strpos(self.link, '?') == false and self.link .. '?' .. append or self.link .. '&' .. append
end

function _M:icon(size)

    size = size or 40
    -- dd($this);
    if not self.favicon then
        
        return Ah.cdn('assets/images/emoji/arrow_right.png')
    end
    local path = 'uploads/sites/' .. self.favicon
    if str.strpos(path, '.ico') == false then
        
        return Ah.cdn(path) .. "?imageView2/1/w/{size}/h/{size}"
    else 
        
        return Ah.cdn(path)
    end
end

return _M

