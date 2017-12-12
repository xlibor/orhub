
return function(cmd)
    
    cmd:add('lxhub/install', 'install@run')
    
    cmd:add('topics/blog_topics', 'migrateBlogTopicRelationship@run')
    cmd:add('lxhub/calculateActiveUser', 'calculateActiveUser@run')
    cmd:add('lxhub/calculateHotTopic', 'calculateHotTopic@run')
    cmd:add('lxhub/initRbac', 'initRbac@run')
    cmd:add('lxhub/gather/obp', 'gather-openresty-best-practices@run')
    cmd:add('lxhub/gather/ggs', 'gather-google-groups@run')
    cmd:add('lxhub/gather/nlmzw', 'gather-nginx-lua-module-zh-wiki@run')
end

