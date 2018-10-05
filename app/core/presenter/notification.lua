
local lx, _M = oo{
    _cls_ = '',
    _ext_ = 'presenter'
}

local app, lf, tb, str = lx.kit()

local lang = Ah.lang

function _M:lableUp()

    local st = self.type
    if st == 'new_topic_from_subscribe' then
        lable = "在你订阅的专栏中发布了"
    elseif st == 'mentioned_in_topic' then
        lable = "在话题中提及你"
    elseif st == 'new_topic_from_following' then
        lable = "你关注的用户发布了新话题"
    elseif st == 'new_reply' then
        lable = lang('Your topic have new reply:')
    elseif st == 'attention' then
        lable = lang('Attented topic has new reply:')
    elseif st == 'attented_append' then
        lable = lang('Attented topic has new reply:')
    elseif st == 'at' then
        lable = lang('Mention you At:')
    elseif st == 'topic_favorite' then
        lable = lang('Favorited your topic:')
    elseif st == 'topic_attent' then
        lable = lang('Attented your topic:')
    elseif st == 'topic_upvote' then
        lable = lang('Up Vote your topic')
    elseif st == 'reply_upvote' then
        lable = lang('Up Vote your reply')
    elseif st == 'topic_mark_wiki' then
        lable = lang('has mark your topic as wiki:')
    elseif st == 'topic_mark_excellent' then
        lable = lang('has recomended your topic:')
    elseif st == 'comment_append' then
        lable = lang('Commented topic has new update:')
    elseif st == 'vote_append' then
        lable = lang('Attented topic has new update:')
    elseif st == 'follow' then
        lable = lang('Someone following you')
    else 
    end
    
    return lable
end

-- for API
function _M:message()

    local message = self.fromUser.name .. ' ⋅ ' .. self:lableUp()
    if #self.topic > 0 then
        message = message .. ' ⋅ ' .. self.topic.title
    end
    
    return message
end

return _M

