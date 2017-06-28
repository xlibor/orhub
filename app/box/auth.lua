
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'serviceProvider'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        policies = {
        ['App\\Model'] = 'App\\Policies\\ModelPolicy',
        ['\App\Models\User.class'] = \App\Policies\UserPolicy.class,
        ['\App\Models\Topic.class'] = \App\Policies\TopicPolicy.class,
        ['\App\Models\Reply.class'] = \App\Policies\ReplyPolicy.class,
        ['\App\Models\Blog.class'] = \App\Policies\BlogPolicy.class,
        ['\App\Models\Thread.class'] = \App\Policies\ThreadPolicy.class
    }
    }
    
    return oo(this, mt)
end

-- The policy mappings for the application.
-- @var table
-- Register any application authentication / authorization services.
-- @param  \Illuminate\Contracts\Auth\Access\Gate  gate


function _M:boot(gate)

    self:registerPolicies(gate)
    --
end

return _M

