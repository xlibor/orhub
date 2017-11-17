
local lx, _M = oo{
    _cls_       = '',
    _ext_       = 'model',
    _static_    = {
    }
}

local app, lf, tb, str, new = lx.kit()

local static

function _M._init_(this)

    static = this.static
end

function _M.s__.newUser(driver)

    static.collect('new_user')
    local st = driver
    if st == 'github' then
        static.collect('new_user_from_github')
    elseif st == 'wechat' then
        static.collect('new_user_from_wechat')
    end
end

function _M.s__.newTopic()

    static.collect('new_topic')
end

function _M.s__.newReply()

    static.collect('new_reply')
end

function _M.s__.newImage()

    static.collect('new_image')
end

-- Collection site status

function _M.s__.collect(subject)

    local today = Dt.now():toDateString()
    local todayStatus = SiteStatus.where('day', today):first()
    if not todayStatus then
        todayStatus = new('.app.model.siteStatus')
        todayStatus.day = today
    end
    local st = subject
    if st == 'new_user' then
        todayStatus.register_count = (todayStatus.register_count or 0) + 1
    elseif st == 'new_topic' then
        todayStatus.topic_count = (todayStatus.topic_count or 0) + 1
    elseif st == 'new_reply' then
        todayStatus.reply_count = (todayStatus.reply_count or 0) + 1
    elseif st == 'new_image' then
        todayStatus.image_count = (todayStatus.image_count or 0) + 1
    elseif st == 'new_user_from_github' then
        todayStatus.github_regitster_count = (todayStatus.github_regitster_count or 0) + 1
    elseif st == 'new_user_from_wechat' then
        todayStatus.wechat_registered_count = (todayStatus.wechat_registered_count or 0) + 1
    end

    todayStatus:save()
end

return _M

