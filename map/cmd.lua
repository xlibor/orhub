
return function(cmd)

    cmd:add('topics/blog_topics', 'migrateBlogTopicRelationship@run')
    cmd:add('lxhub/calculateActiveUser', 'calculateActiveUser@run')
    cmd:add('lxhub/calculateHotTopic', 'calculateHotTopic@run')
end

