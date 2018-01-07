
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    Db.table('blogs'):delete()
    Db.table('blogs'):inserts({
    {
        id = 1,
        name = 'ngx+lua中文文档',
        slug = 'ngx-lua-module-zh-wiki',
        description = 'ngx+lua中文文档镜像',
        cover = 'https://dn-phphub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 2,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-10-17 10:00:00',
        updated_at = '2017-10-17 10:00:00'
    },
    {
        id = 2,
        name = 'openresty conf',
        slug = 'openresty-conf',
        description = 'openresty conf',
        cover = 'https://dn-phphub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 2,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-10-17 10:00:00',
        updated_at = '2017-10-17 10:00:00'
    },
    {
        id = 3,
        name = 'openresty最佳实践',
        slug = 'openresty-best-practices',
        description = 'openresty best practices 镜像',
        cover = 'https://dn-phphub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 1,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-10-17 10:00:00',
        updated_at = '2017-10-17 10:00:00'
    },
    {
        id = 4,
        name = 'lua程序设计',
        slug = 'programming-in-lua',
        description = 'lua程序设计',
        cover = 'https://dn-phphub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 2,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-10-17 10:00:00',
        updated_at = '2017-10-17 10:00:00'
    },
    {
        id = 5,
        name = 'nginx中文文档',
        slug = 'nginx-docs-zh',
        description = 'nginx中文文档',
        cover = 'https://dn-phphub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 2,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-10-17 10:00:00',
        updated_at = '2017-10-17 10:00:00'
    },
    {
        id = 6,
        name = 'lxlib文档',
        slug = 'lxlib-docs-zh',
        description = 'lxlib文档',
        cover = 'https://dn-phphub.qbox.me/uploads/images/201701/16/1/9Il9wyivOg.png',
        user_id = 2,
        article_count = 0,
        subscriber_count = 0,
        is_recommended = 0,
        is_blocked = 0,
        created_at = '2017-10-17 10:00:00',
        updated_at = '2017-10-17 10:00:00'
    }
    })
end

return _M

