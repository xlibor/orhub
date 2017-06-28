
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:removeBy(causer, indentifier)

    Activity.where('causer', causer):where('indentifier', indentifier):where('type', class_basename(get_class(self))):delete()
end

function _M:addTopicActivity(user, topic, extra_data, indentifier)

    extra_data = extra_data or {}
    -- 站务不显示
    if topic.category_id == config('phphub.admin_board_cid') then
        
        return
    end
    local causer = 'u' .. user.id
    indentifier = indentifier or 't' .. topic.id
    local data = tb.merge({
        topic_type = topic:isArticle() and 'article' or 'topic',
        topic_link = topic:link(),
        topic_title = topic.title,
        topic_category_id = topic.category.id,
        topic_category_name = topic.category.name
    }, extra_data)
    self:addActivity(causer, user, indentifier, data)
end

function _M:addActivity(causer, user, indentifier, data)

    local type = class_basename(get_class(self))
    tapd(activities, {)
        causer = causer,
        user_id = user.id,
        type = type,
        indentifier = indentifier,
        data = serialize(data),
        created_at = Carbon.now():toDateTimeString(),
        updated_at = Carbon.now():toDateTimeString()
    }
    Activity.insert(activities)
end

return _M

