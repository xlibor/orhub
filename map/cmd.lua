
return function(cmd)

    cmd:add('orhub/install', 'install')
    
    cmd:add('orhub/topics/blog_topics', 'migrateBlogTopicRelationship@run')
    cmd:add('orhub/calculateActiveUser', 'calculateActiveUser@run')
    cmd:add('orhub/calculateHotTopic', 'calculateHotTopic@run')
    cmd:add('orhub/initRbac', 'initRbac@run')
end

