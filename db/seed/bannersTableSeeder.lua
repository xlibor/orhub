
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    Db.table('banners'):delete()
    Db.table('banners'):inserts({
    {
        id = 1,
        position = 'website_top',
        order = 1,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/qCpz5a1iBETEfnNEAkGe.png',
        title = 'openresty 中文文档',
        link = 'https://doc.laravel-china.org/docs/5.1',
        target = '_blank',
        description = 'ngx+lua 中文文档汇总',
        created_at = '2016-07-12 11:31:36',
        updated_at = '2016-07-12 11:31:36'
    },
    {
        id = 3,
        position = 'website_top',
        order = 3,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/YCkIqPrz6v8MV0keu4pW.png',
        title = 'openresty最佳实践',
        link = 'https://cs.laravel-china.org/',
        target = '_blank',
        description = 'openresty最佳实践整理',
        created_at = '2016-07-12 11:32:25',
        updated_at = '2016-07-12 11:32:25'
    },
    {
        id = 4,
        position = 'website_top',
        order = 2,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/0wgbAVabZB9GA2yaU8AY.png',
        title = 'openresty conf',
        link = 'categories/1',
        target = '_self',
        description = 'openresty conf 2016, 2017 ...',
        created_at = '2016-07-12 11:33:05',
        updated_at = '2016-07-12 15:03:56'
    },
    {
        id = 5,
        position = 'website_top',
        order = 4,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/0pyH7UgXhF7PTBkLZRak.png',
        title = 'google groups讨论',
        link = 'https://psr.lxhub.org/',
        target = '_blank',
        description = 'google groups讨论贴镜像',
        created_at = '2016-07-12 11:33:40',
        updated_at = '2016-07-12 11:33:40'
    },
    {
        id = 6,
        position = 'sidebar-resources',
        order = 6,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/HCNo4rSRxIpK12yDL13U.png',
        title = 'lua中文教程',
        link = 'http://laravel-china.github.io/php-the-right-way/',
        target = '_blank',
        description = 'lua中文教程',
        created_at = '2016-07-12 11:34:07',
        updated_at = '2016-07-12 11:34:07'
    },
    {
        id = 7,
        position = 'sidebar-resources',
        order = 5,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/EptWCkT1qDDvtn5nV2id.png',
        title = 'lxlib 文档',
        link = 'http://laravel-china.org/api/5.1/',
        target = '_blank',
        description = 'lxlib 文档',
        created_at = '2016-07-12 11:34:36',
        updated_at = '2016-07-12 15:05:09'
    },
    {
        id = 8,
        position = 'sidebar-resources',
        order = 5,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/EptWCkT1qDDvtn5nV2id.png',
        title = 'luarocks, opm包整理',
        link = 'http://laravel-china.org/api/5.1/',
        target = '_blank',
        description = 'luarocks, opm包整理',
        created_at = '2016-07-12 11:34:36',
        updated_at = '2016-07-12 15:05:09'
    },
    })
end

return _M

