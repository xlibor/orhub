-- @TYPO3\Flow\Annotations\Proxy(false)


local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = '\SimpleXMLElement'
}

local app, lf, tb, str = lx.kit()

-- Adds a new child node - and replaces "&" by "&amp;" on the way ...
-- @param string name Name of the tag
-- @param string value The tag value, if any
-- @param null namespace The tag namespace, if any
-- @return \SimpleXMLElement

function _M:addChild(name, value, namespace)

    namespace = namespace or NULL
    value = value or NULL
    
    return parent.addChild(name, value ~= NULL and str.replace(value, '&', '&amp;') or NULL, namespace)
end

-- Adds a new attribute - and replace "&" by "&amp;" on the way ...
-- @param string name Name of the attribute
-- @param string value The value to set, if any
-- @param string namespace The namespace, if any

function _M:addAttribute(name, value, namespace)

    namespace = namespace or NULL
    value = value or NULL
    parent.addAttribute(name, value ~= NULL and str.replace(value, '&', '&amp;') or NULL, namespace)
end

-- Pretty much like addChild() but wraps the value in CDATA
-- @param string name tag name
-- @param string value tag value


function _M:addCdataChild(name, value)

    local child = self:addChild(name)
    child:setChildCdataValue(value)
end

-- Sets a cdata value for this child
-- @param string value The value to be enclosed in CDATA


function _M.__:setChildCdataValue(value)

    local domNode = dom_import_simplexml(self)
    domNode:appendChild(domNode.ownerDocument:createCDATASection(value))
end

return _M

