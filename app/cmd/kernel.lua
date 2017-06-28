
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'consoleKernel'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        commands = {Commands\Inspire.class, Commands\ESTReinstallCommand.class, Commands\ESTInstallCommand.class, Commands\ESTDatabaseResetCommand.class, Commands\ESTDatabaseNukeCommand.class, Commands\ESTInitRBAC.class, Commands\CalculateActiveUser.class, Commands\CalculateHotTopic.class, Commands\ClearUserData.class, Commands\SyncUserActivedTime.class, Commands\CalculateMaintainerWorks.class, Commands\SendMaintainerWorksMail.class, Commands\TopicImagesRecollect.class, Commands\TopicSlugMigration.class, Commands\MigrateBlogTopicRelationship.class}
    }
    
    return oo(this, mt)
end

-- The Artisan commands provided by your application.
-- @var table
-- Define the application's command schedule.
-- @param  \Illuminate\Console\Scheduling\Schedule  schedule


function _M.__:schedule(schedule)

    schedule:command('inspire'):hourly()
    -- 数据库备份
    schedule:command('backup:run --only-db'):cron('0 */4 * * * *')
    schedule:command('backup:clean'):daily():at('00:10')
    schedule:command('backup:monitor'):daily():at('10:00')
    -- schedule->command('phphub:calculate-maintainer-works--send-mail=yes')->mondays()->at('00:05');
    schedule:command('phphub:calculate-active-user'):everyTenMinutes()
    schedule:command('phphub:calculate-hot-topic'):everyTenMinutes()
    schedule:command('phphub:sync-user-actived-time'):everyTenMinutes()
end

return _M

