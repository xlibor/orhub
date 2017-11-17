
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()
local lang = Ah.lang
local redirect = lx.h.redirect

local use = lx.use
local UserAttendedTopic = use('.app.activity.userAttendedTopic')
local Attention = use('.app.model.attention')
local Notification = use('.app.model.notification')

function _M:ctor()

    self:setBar('auth')
end

function _M:createOrDelete(c, id)

    local message
    local topic = Topic.find(id)
    if Attention.isUserAttentedTopic(Auth.user(), topic) then
        message = lang('Successfully remove attention.')
        Auth.user():attentTopics():detach(topic.id)
        app(UserAttendedTopic):remove(Auth.user(), topic)
    else 
        message = lang('Successfully_attention')
        Auth.user():attentTopics():attach(topic.id)
        Notification.notify('topic_attent', Auth.user(), topic('user'), topic)
        app(UserAttendedTopic):generate(Auth.user(), topic)
    end
    Flash.success(message)
    
    return redirect():back()
end

return _M

