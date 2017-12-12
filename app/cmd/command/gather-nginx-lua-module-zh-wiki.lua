
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'command'
}

local app, lf, tb, str, new = lx.kit()
local fs, use               = lx.fs, lx.use
 
local Markdown              = use('.app.core.markdown.markdown')
local TopicDoer             = use('.app.http.doer.topic')
local User                  = use('.app.model.user')
local Blog                  = use('.app.model.blog')

local sfind, ssub, smatch   = string.find, string.sub, string.match
local sgsub                 = string.gsub

function _M:ctor()

    self.description = 'gathering [ngx-lua-module-zh-wiki] pages'
    self.markdownDir = '/vagrant/res/ngx-lua-module-zh-wiki'
    self.topics = {}
    self.blogName = 'ngx-lua-module-zh-wiki'
    self.slugPrefix = self.blogName .. '-'
    self.titles = {}
end

function _M:run()

    self:parseDoc()
end

function _M.__:parseDoc()

    local docPath = self.markdownDir .. '/doc.md'
    if not fs.exists(docPath) then
        error('not found' .. docPath)
    end

    local docMd = fs.get(docPath)
    docMd = sgsub(docMd, "<!%-%-.-%-%->", '')
    local ngxDirsBegin = sfind(docMd, "lua_use_default_type" .. "\n" .. "%-%-")
    local ngxApisBegin = sfind(docMd, "Nginx API for Lua" .. "\n" .. "=================", ngxDirsBegin)

    local ngxDirsContent = ssub(docMd, ngxDirsBegin, ngxApisBegin - 1)
    local dirList = str.split(ngxDirsContent, "%[返回目录%]" .. "[^\n]+\n", _, true)
    tb.pop(dirList)

    ngxApisBegin = sfind(docMd, "ngx.arg" .. "\n" .. "%-%-", ngxApisBegin)
    local ngxApisEnd = sfind(docMd, "Obsolete Sections" .. "\n" .. "=================", ngxApisBegin)
    local ngxApisContent = ssub(docMd, ngxApisBegin, ngxApisEnd - 1)
    local apiList = str.split(ngxApisContent, "%[返回目录%]" .. "[^\n]+\n", _, true)
    tb.pop(apiList)

    self:generateTopics(dirList)
    self:generateTopics(apiList)

    self:updateBlogSummary(dirList, apiList)
end

function _M.__:generateTopics(list)

    for i, info in ipairs(list) do
        info = str.trim(info, '\n')
        info = str.trim(info)
        local title, body = smatch(info, '(.-)\n%-+\n(.*)')
        list[i] = title
        echo(title)
        echo('==============')
        self:createTopic(title, body)
    end

end

function _M.__:createTopic(title, md)

    local user = self:getUser()
    local blog = self:getBlog()

    local slug = self.slugPrefix .. str.slug(title)

    local data = {
        title = title,
        slug = slug,
        body = md, 
        category_id = 8,
        tags = nil
    }

    return new(TopicDoer):create(self, user, data, false, blog)
end

function _M.__:updateBlogSummary(dirList, apiList)

    local topics = self.topics
    local topic

    local summaryMd = {}
    tapd(summaryMd, "* ngx+lua 指令")
    for _, title in ipairs(dirList) do
        topic = topics[title]
        if topic then
            tapd(summaryMd, "    * " .. "(aid:" .. topic.id .. ")")
        end
    end

    tapd(summaryMd, "* ngx+lua api")
    for _, title in ipairs(apiList) do
        topic = topics[title]
        if topic then
            tapd(summaryMd, "    * " .. "(aid:" .. topic.id .. ")")
        end
    end
    
    summaryMd = str.join(summaryMd, '\n')
    local summary = new(Markdown):parseBlogSummary(
        summaryMd, self:getUser():topics():get():col()
    )
    local blog = self:getBlog()
    blog.summary_original = summaryMd
    blog.summary = summary
    blog:save()
end

function _M:creatorSucceed(topic)

    self.topics[topic.title] = topic
end

function _M.__:getUser()

    return User.find(1)
end

function _M.__:getBlog()

    return Blog.find(2)
end

return _M

