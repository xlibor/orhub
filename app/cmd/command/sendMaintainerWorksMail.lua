
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'orhub:send-maintainer-works-mail {start_time} {end_time}',
        description = 'Send maintainer works mail'
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    local start_time = self:argument('start_time')
    local end_time = self:argument('end_time')
    local logs = MaintainerLog.where('start_time', start_time):where('end_time', end_time):get()
    if not logs then
        
        return 'No data'
    end
    local content = self:generateContent(logs)
    local timeFrame = "{start_time} 至 {end_time}"
    local founders = User.byRolesName(Role.find(1).name)
    local maintainer = User.byRolesName(Role.find(2).name)
    local users = founders:merge(maintainer)
    for _, user in pairs(users) do
        dispatch(new('\App\Jobs\SendMaintainerWorksMail', user, timeFrame, content))
    end
    self:info('Done')
end

function _M.__:generateContent(logs)

    local tdStyle
    local bgColor
    local content = "<table style=\"box-sizing: border-box; border-collapse: collapse; border-spacing: 0px; margin-top: 0px; margin-bottom: 16px; display: block; width: 637px; overflow: auto; word-break: keep-all; font-family: 'Helvetica Neue', Helvetica, 'Segoe UI', Arial, freesans, sans-serif; font-size: 16px;\">\n                    <thead style=\"box-sizing: border-box;\">\n                        <tr style=\"box-sizing: border-box; border-top-width: 1px; border-top-style: solid; border-top-color: rgb(204, 204, 204);\">\n                            <th style=\"box-sizing: border-box; padding: 6px 13px; border: 1px solid rgb(221, 221, 221);\">用户</th>\n                            <th style=\"box-sizing: border-box; padding: 6px 13px; border: 1px solid rgb(221, 221, 221); text-align: center;\">发帖数</th>\n                            <th style=\"box-sizing: border-box; padding: 6px 13px; border: 1px solid rgb(221, 221, 221); text-align: right;\">回复数</th>\n                        </tr>\n                    </thead>\n                    <tbody style=\"box-sizing: border-box;\">"
    for index, log in pairs(logs) do
        bgColor = index % 2 ~= 0 and 'background-color: rgb(248, 248, 248);' or ''
        content = content .. "<tr style=\"box-sizing: border-box; border-top-width: 1px; border-top-style: solid; border-top-color: rgb(204, 204, 204);" .. bgColor .. "\">"
        tdStyle = 'box-sizing: border-box; padding: 6px 13px; border: 1px solid rgb(221, 221, 221); text-align: center;'
        content = content .. "<td style=\"{tdStyle}\"><a href=\"" .. route('users.show', log.user_id) .. "\" target=\"_blank\">{log.user.name}</a></td>"
        content = content .. "<td style=\"{tdStyle}\">{log.topics_count}</td>"
        content = content .. "<td style=\"{tdStyle}\">{log.replies_count}</a></td>"
        content = content .. "</tr>"
    end
    content = content .. '</tbody></table>'
    
    return content
end

return _M

