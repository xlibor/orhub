
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

-- Auto generated seed file


function _M:run()

    \DB.table('links'):delete()
    \DB.table('links'):insert({
        [0] = {
        id = 1,
        title = 'Ruby China',
        link = 'https://ruby-china.org',
        cover = 'https://dn-lxhub.qbox.me/assets/images/friends/ruby-china.png',
        created_at = '2014-10-12 08:29:15',
        updated_at = '2014-10-31 06:01:20'
    },
        [1] = {
        id = 2,
        title = 'Golang 中国',
        link = 'http://golangtc.com/',
        cover = 'https://dn-lxhub.qbox.me/assets/images/friends/golangcn.png',
        created_at = '2014-10-12 08:29:15',
        updated_at = '2014-10-31 06:04:39'
    },
        [2] = {
        id = 3,
        title = 'CNode：Node.js 中文社区',
        link = 'http://cnodejs.org/',
        cover = 'https://dn-lxhub.qbox.me/assets/images/friends/cnodejs.png',
        created_at = '2014-10-12 08:29:15',
        updated_at = '2014-10-31 06:05:03'
    },
        [3] = {
        id = 4,
        title = 'ElixirChina (ElixirCN) ',
        link = 'http://elixir-cn.com/',
        cover = 'https://dn-lxhub.qbox.me/f65fb5a10d3392a1db841c85716dd8f6.png',
        created_at = '2014-10-12 08:29:15',
        updated_at = '2015-01-15 00:07:38'
    },
        [4] = {
        id = 5,
        title = 'Ionic China',
        link = 'http://ionichina.com/',
        cover = 'https://dn-lxhub.qbox.me/assets/images/friends/ionic.png',
        created_at = '0000-00-00 00:00:00',
        updated_at = '0000-00-00 00:00:00'
    },
        [5] = {
        id = 6,
        title = 'Tester Home',
        link = 'https://testerhome.com',
        cover = 'https://dn-lxhub.qbox.me/testerhome-logo.png',
        created_at = '2015-05-17 11:37:40',
        updated_at = '2015-05-17 11:37:40'
    },
        [6] = {
        id = 7,
        title = 'Laravel So',
        link = 'http://laravel.so/',
        cover = 'http://laravel.so/img/site-logo.png',
        created_at = '2015-05-17 11:37:40',
        updated_at = '2015-05-17 11:37:40'
    }
    })
end

return _M

