
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'seeder'
}

local app, lf, tb, str = lx.kit()

function _M:run()

    Db.table('oauth_clients'):delete()
    Db.table('oauth_clients'):inserts({{
        id = '14n5UsWFzhrt8iPx82wz',
        secret = 'j48EpY29pF06i7cAhEx6dgSTLD7',
        name = 'Test Drive',
        user_id = '1',
        created_at = '2014-10-12 08:29:15',
        updated_at = '2014-10-31 06:01:20'
    }})
end

return _M

