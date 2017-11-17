
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'presenter'
}

local app, lf, tb, str = lx.kit()
local url = lx.h.url

function _M:topicFilter(filter)

    local link
    local category_id = Req.segment(2)
    local category_append = ''
    if Req.is('categories*') and category_id then
        link = url('categories', category_id) .. '?filter=' .. filter
    else 
        query_append = ''
        query = Req.except('filter', '_pjax')
        if query then
            query_append = '&' .. lf.httpBuildQuery(query)
        end
        link = Url.to('topics') .. '?filter=' .. filter .. query_append .. category_append
    end
    local selected = Req.get('filter') and Req.get('filter') == filter and ' class="active"' or '' or (filter == 'default' and ' class="active"' or '')
    
    return 'href="' .. link .. '"' .. selected
end

function _M:voteState(vote_type)

    if self:votes():byWhom(Auth.id()):withType(vote_type):count() then
        
        return 'active'
    else 
        
        return
    end
end

function _M:replyFloorFromIndex(index)

    index = index + 1
    local current_page = Req.input('page') or 1

    return (current_page - 1) * app:conf('lxhub.repliesPerpage') + index
end

return _M

