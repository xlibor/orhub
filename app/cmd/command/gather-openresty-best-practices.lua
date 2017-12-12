
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

function _M:ctor()

    self.description = 'gathering [openresty-best-practices] pages'
    self.markdownDir = '/vagrant/res/openresty-best-practices-master'
    self.topics = {}
    self.blogName = 'openresty-best-practices'
    self.slugPrefix = self.blogName .. '-'
end

function _M:run()

    self:parseSummary()

end

function _M.__:parseSummary()

    local summaryPath = self.markdownDir .. '/SUMMARY.md'
    if not fs.exists(summaryPath) then
        error('not found' .. summaryPath)
    end

    local summaryMd = fs.get(summaryPath)
    summaryMd = str.gsub(summaryMd, '\n\n', '')
    local summary = new(Markdown):convertMarkdownToHtml(summaryMd)
    
    local dom = new('domDocument'):loadHtml(summary)
    rootUl = dom:find('/ul')
    if #rootUl == 0 then
        error('not found root ul')
    end
    
    local links = {}
    local topUl = rootUl[1]

    self:getLinks(links, topUl.childNodes)
    self:generateTopics(links)
    self:updateBlogSummary(summaryMd, summary)
    self:copyImages()
end

function _M.__:copyImages()

    fs.copy(self.markdownDir .. '/images/*',
        lx.dir('pub', 'uploads/blog/' .. self.blogName .. '/')
    )
end

function _M.__:updateBlogSummary(summaryMd, summary)

    local topics = self.topics
    local pat = [[(href="([^"]+)")]]

    summary = str.regsub(summary, pat, function(m)
        local path = str.div(m[2], '.')
        path = str.gsub(path, '/', '-')
        local slug = self.slugPrefix .. str.slug(path)
        local topic = topics[slug]

        if topic then
            echo(slug)
            return 'href="/articles/' .. topic.id .. '/' ..
                topic.slug .. '"'
        else
            return m[1]
        end
    end)

    local blog = self:getBlog()
    blog.summary_original = summaryMd
    blog.summary = summary
    blog:save()
end

function _M.__:generateTopics(links)

    local node, href, linkPath
    for _, link in ipairs(links) do
        if link.node then
            node = link.node
            href = node.href
            title = node.textContent
            -- echo(title)
            self:createTopic(href, title)
        end
    end

end

function _M.__:createTopic(href, title)

    local user = self:getUser()
    local blog = self:getBlog()
    local path = self.markdownDir .. '/' .. href
    href = str.div(href, '.')
    href = str.gsub(href, '/', '-')
    local slug = self.slugPrefix .. str.slug(href)
    local md = fs.get(path)

    md = str.gsub(md, '%(%.%./images/', '(/uploads/blog/' ..
        self.blogName .. '/')

    local data = {
        title = title,
        slug = slug,
        body = md, 
        category_id = 8,
        tags = nil
    }

    return new(TopicDoer):create(self, user, data, false, blog)
end

function _M:creatorSucceed(topic)

    self.topics[topic.slug] = topic
end

function _M.__:getUser()

    return User.find(1)
end

function _M.__:getBlog()

    return Blog.find(1)
end

function _M.__:getLinks(links, nodes)

    local subNodes, link, ul, text
    for i, e in ipairs(nodes) do

        if e.nodeName == 'li' then
            link = e.childNodes[1]
            if link.nodeName == 'a' then
                tapd(links, {node = link, level = e.level})
            else
                text = e.textContent
                text = str.str(text, '\n', true)
                tapd(links, {text = text, level = e.level})
            end

            local ulList = e('/ul')
            if #ulList > 0 then
                ul = ulList[1]
                self:getLinks(links, ul.childNodes)
            else

            end
        end
    end
end

return _M

