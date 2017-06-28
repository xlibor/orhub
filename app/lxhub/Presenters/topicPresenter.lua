
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'presenter'
}

local app, lf, tb, str = lx.kit()

function _M:topicFilter(filter)

    local link
    local category_id = Request.segment(2)
    local category_append = ''
    if Request.is('categories*') and category_id then
        link = url('categories', category_id) .. '?filter=' .. filter
    else 
        query_append = ''
        query = Input.except('filter', '_pjax')
        if query then
            query_append = '&' .. lf.httpBuildQuery(query)
        end
        link = URL.to('topics') .. '?filter=' .. filter .. query_append .. category_append
    end
    local selected = Input.get('filter') and Input.get('filter') == filter and ' class="active"' or '' or (filter == 'default' and ' class="active"' or '')
    
    return 'href="' .. link .. '"' .. selected
end

function _M:voteState(vote_type)

    if self:votes():ByWhom(Auth.id()):WithType(vote_type):count() then
        
        return 'active'
    else 
        
        return
    end
end

function _M:replyFloorFromIndex(index)

    index = index + 1
    local current_page = Input.get('page') or 1
    
    return (current_page - 1) * Config.get('phphub.replies_perpage') + index
end

return _M

