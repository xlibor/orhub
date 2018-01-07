
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    Db.table('banners'):delete()
    Db.table('banners'):inserts({
    {
        position = 'website_top',
        order = 1,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/qCpz5a1iBETEfnNEAkGe.png',
        title = 'openresty 中文文档',
        link = '/b/ngx-lua-module-zh-wiki',
        target = '_blank',
        description = 'ngx+lua 中文文档汇总',
        created_at = '2017-10-05 11:31:36',
        updated_at = '2017-10-05 11:31:36'
    },
    {
        position = 'website_top',
        order = 2,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/0wgbAVabZB9GA2yaU8AY.png',
        title = 'openresty conf',
        link = '/b/openresty-conf',
        target = '_self',
        description = 'openresty conf, meetups资料, 视频汇总',
        created_at = '2017-10-05 11:33:05',
        updated_at = '2017-10-05 15:03:56'
    },
    {
        position = 'website_top',
        order = 3,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/YCkIqPrz6v8MV0keu4pW.png',
        title = 'openresty最佳实践',
        link = '/b/openresty-best-practices',
        target = '_blank',
        description = 'openresty最佳实践整理, 定时更新',
        created_at = '2017-10-05 11:32:25',
        updated_at = '2017-10-05 11:32:25'
    },
    {
        position = 'website_top',
        order = 4,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/0pyH7UgXhF7PTBkLZRak.png',
        title = 'google groups讨论',
        link = 'http://orhub.test/c/9',
        target = '_blank',
        description = 'google groups讨论贴镜像',
        created_at = '2017-10-05 11:33:40',
        updated_at = '2017-10-05 11:33:40'
    },
    {
        position = 'website_top',
        order = 5,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/0pyH7UgXhF7PTBkLZRak.png',
        title = 'lua程序设计',
        link = 'b/programming-in-lua',
        target = '_blank',
        description = 'lua程序设计, 中文教程',
        created_at = '2017-10-05 11:33:40',
        updated_at = '2017-10-05 11:33:40'
    },
    {
        position = 'website_top',
        order = 6,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/EptWCkT1qDDvtn5nV2id.png',
        title = 'nginx中文文档',
        link = 'b/nginx-docs-zh',
        target = '_blank',
        description = 'nginx中文文档',
        created_at = '2017-10-05 11:34:36',
        updated_at = '2017-10-05 15:05:09'
    },
    {
        position = 'website_top',
        order = 7,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/HCNo4rSRxIpK12yDL13U.png',
        title = 'nginx开发指南',
        link = 'topics/1/nginx-development-guide',
        target = '_blank',
        description = 'nginx开发指南',
        created_at = '2017-10-05 11:34:07',
        updated_at = '2017-10-05 11:34:07'
    },
    {
        position = 'website_top',
        order = 8,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/EptWCkT1qDDvtn5nV2id.png',
        title = 'resty资源推荐',
        link = '/topics/2/awesome-resty-zh',
        target = '_blank',
        description = 'openresty资源推荐汇总',
        created_at = '2017-10-05 11:34:36',
        updated_at = '2017-10-05 15:05:09'
    },
    {
        position = 'website_top',
        order = 9,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/EptWCkT1qDDvtn5nV2id.png',
        title = 'opm,luarocks包推荐',
        link = '/topics/3/opm-luarocks-modules',
        target = '_blank',
        description = 'opm, luarocks组件汇总推荐',
        created_at = '2017-10-05 11:34:36',
        updated_at = '2017-10-05 15:05:09'
    },
    {
        position = 'website_top',
        order = 10,
        image_url = 'https://dn-phphub.qbox.me/uploads/banners/EptWCkT1qDDvtn5nV2id.png',
        title = 'lxlib文档',
        link = '/b/lxlib-docs-zh',
        target = '_blank',
        description = 'lxlib文档',
        created_at = '2017-10-05 11:34:36',
        updated_at = '2017-10-05 15:05:09'
    },
    })
end

return _M

