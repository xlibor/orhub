
return function(cmd)
    
    cmd:add('lxhub/install', 'install')
    
    cmd:add('lxhub/topics/blog_topics', 'migrateBlogTopicRelationship@run')
    cmd:add('lxhub/calculateActiveUser', 'calculateActiveUser@run')
    cmd:add('lxhub/calculateHotTopic', 'calculateHotTopic@run')
    cmd:add('lxhub/initRbac', 'initRbac@run')
end

