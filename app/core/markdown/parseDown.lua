
local lx, _M, mt = oo{
	_cls_ = ''
}

local md = require('discount')

function _M:new()

	local this = {

	}

	return oo(this, mt)
end

function _M:text(s)

    local doc, err = md.compile(s, 'toc')
    
    if doc then 
    	s = doc.body
    else
    	error(err)
 	end

	return s
end

return _M

