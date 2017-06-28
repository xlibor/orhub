
local lx, _M, mt = oo{
    _cls_ = ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        version = '',
        encoding = '',
        channel = {},
        items = {},
        limit = 0
    }
    
    return oo(this, mt)
end

function _M:feed(version, encoding)

    self.version = version
    self.encoding = encoding
    
    return self
end

-- Parameters :
-- - title (required)
-- - link (required)
-- - description (required)
-- - language
-- - copyright
-- - managingEditor
-- - webMaster
-- - pubDate
-- - lastBuildDate
-- - category
-- - generator
-- - docs
-- - cloud
-- - ttl
-- - image
-- - rating
-- - textInput
-- - skipHours
-- - skipDays

function _M:channel(parameters)

    if not tb.has(parameters, 'title') or not tb.has(parameters, 'description') or not tb.has(parameters, 'link') then
        lx.throw(\Exception, 'Parameter required missing : title, description or link')
    end
    self.channel = parameters
    
    return self
end

-- Parameters :
-- - title
-- - link
-- - description
-- - author
-- - category
-- - comments
-- - enclosure
-- - guid
-- - pubDate
-- - source

function _M:item(parameters)

    if lf.isEmpty(parameters) then
        lx.throw(\Exception, 'Parameter missing')
    end
    tapd(self.items, parameters)
    
    return self
end

function _M:limit(limit)

    if lf.isNum(limit) and limit > 0 then
        self.limit = limit
    end
    
    return self
end

function _M:render()

    local options
    local elem_item
    local xml = new('simpleXMLElement', '<?xml version="1.0" encoding="' .. self.encoding .. '"?><rss version="' .. self.version .. '" xmlns:content="http://purl.org/rss/1.0/modules/content/" xmlns:wfw="http://wellformedweb.org/CommentAPI/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:atom="http://www.w3.org/2005/Atom" xmlns:sy="http://purl.org/rss/1.0/modules/syndication/" xmlns:slash="http://purl.org/rss/1.0/modules/slash/"></rss>', LIBXML_NOERROR | LIBXML_ERR_NONE | LIBXML_ERR_FATAL)
    xml:addChild('channel')
    for kC, vC in pairs(self.channel) do
        xml.channel:addChild(kC, vC)
    end
    local items = self.limit > 0 and tb.slice(self.items, 0, self.limit) or self.items
    for _, item in pairs(items) do
        elem_item = xml.channel:addChild('item')
        for kI, vI in pairs(item) do
            options = str.split(kI, '|')
            if tb.inList(options, 'cdata') then
                elem_item:addCdataChild(options[0], vI)
            elseif str.strpos(options[0], ':') ~= false then
                elem_item:addChild(options[0], vI, 'http://purl.org/dc/elements/1.1/')
            else 
                elem_item:addChild(options[0], vI)
            end
        end
    end
    
    return xml
end

function _M:save(filename)

    return self:render():asXML(filename)
end

function _M:__toString()

    return self:render():asXML()
end

return _M

