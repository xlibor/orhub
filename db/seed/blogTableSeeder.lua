-- composer require laracasts/testdummy


local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    \DB.table('blogs'):delete()
    \DB.table('blogs'):insert({[0] = {
        id = 1,
        name = '我的专栏',
        slug = 'myblog',
        description = '记录工作日志',
        cover = 'https://dn-lxhub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 1,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-01-17 14:35:47',
        updated_at = '2017-01-17 14:35:47'
    }, [1] = {
        id = 2,
        name = '望洋路12号',
        slug = 'road12',
        description = '记录生活',
        cover = 'https://dn-lxhub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 2,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-01-17 14:35:47',
        updated_at = '2017-01-17 14:35:47'
    }})
end

return _M

