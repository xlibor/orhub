
local lx = require('lxlib')
local env = lx.env

local conf = {
    repliesPerpage = 200,
    activedTimeForUpdate = 'actived_time_for_update',
    activedTimeData = 'actived_time_data',
    blogCategoryId = env('blogCategoryId'),
    googleGroupsCategoryId = env('googleGroupsCategoryId'),
    qaCategoryId = env('qaCategoryId'),
    wikiTopicId = env('wikiTopicId') or 1,
    adminBoardCid = env('adminBoardCid') or 0,
    notifyDelay = 180
}

return conf

