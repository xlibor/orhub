
return function(cmd)
    
    cmd:add('orhub/three', function()
        warn('three once')
    end)

    cmd:add('orhub/four', function()
        warn('four once')
    end)

    cmd:add('orhub/five', function()
        warn('five once')
    end)

    cmd:add('orhub/install', 'install')
    
    cmd:add('orhub/topics/blog_topics', 'migrateBlogTopicRelationship@run')
    cmd:add('orhub/calculateActiveUser', 'calculateActiveUser@run')
    cmd:add('orhub/calculateHotTopic', 'calculateHotTopic@run')
    cmd:add('orhub/initRbac', 'initRbac@run')
end

