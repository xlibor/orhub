
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self:middleware('auth')
end

function _M:createOrDelete(id)

    local message
    local topic = Topic.find(id)
    if Attention.isUserAttentedTopic(Auth().user, topic) then
        message = lang('Successfully remove attention.')
        Auth().user:attentTopics():detach(topic.id)
        app(UserAttendedTopic.class):remove(Auth().user, topic)
    else 
        message = lang('Successfully_attention')
        Auth().user:attentTopics():attach(topic.id)
        Notification.notify('topic_attent', Auth().user, topic.user, topic)
        app(UserAttendedTopic.class):generate(Auth().user, topic)
    end
    Flash.success(message)
    
    return Redirect.back()
end

return _M

