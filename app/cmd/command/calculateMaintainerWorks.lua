
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        signature = 'phphub:calculate-maintainer-works {--send-mail=no}',
        description = 'Calculate maintainer works'
    }
    
    return oo(this, mt)
end

function _M:ctor()

    parent.__construct()
end

function _M:handle()

    local sink_count
    local excellent_count
    local replies_count
    local topics_count
    local data
    local start_time = Carbon.now():subDays(7):toDateString()
    local end_time = Carbon.now():toDateString()
    MaintainerLog.where('start_time', start_time):where('end_time', end_time):delete()
    local role = Role.find(2)
    local maintainers = User.byRolesName(role.name)
    for _, user in pairs(maintainers) do
        data = {}
        topics_count = user:topics():whereBetween('created_at', {start_time, end_time}):count()
        replies_count = user:replies():whereBetween('created_at', {start_time, end_time}):count()
        excellent_count = user:revisions():where('key', 'is_excellent'):whereBetween('created_at', {start_time, end_time}):count()
        sink_count = user:revisions():where('key', 'order'):whereBetween('created_at', {start_time, end_time}):count()
        data = compact('topics_count', 'replies_count', 'excellent_count', 'sink_count')
        data['user_id'] = user.id
        data['start_time'] = start_time
        data['end_time'] = end_time
        MaintainerLog.create(data)
    end
    if self:option('send-mail') == 'yes' then
        \Artisan.call('phphub:send-maintainer-works-mail', {start_time = start_time, end_time = end_time})
    end
    self:info('Done')
end

return _M

