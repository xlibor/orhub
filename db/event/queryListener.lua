
local lx, _M, mt = oo{
	_cls_	= ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

	return oo({}, mt)
end

function _M:handle(e, sqlObj)

	local event, q = e.name, e.sender

	local handler = self[event]
	if handler then
		handler(self, q, sqlObj)
	end

	if not q.testMode then
		local sql = q.sql
		if lf.notEmpty(sql) and str.startsWith(event, 'after') then
			-- echo(event, ':', sql .. ' <br>')
		end
	end
end

function _M:beforeSave(q)
 
end

function _M:beforeInsert(q)

end

function _M:beforeUpdate(q)
 
end

function _M:beforeDelete(q)
 
end

function _M:beforeSelect(q)

end

function _M:aroundSelect(q, sqlSelect)

end

function _M:aroundSave(q, sqlSave)
 
end

function _M:afterSave(q)

end

function _M:afterSelect(q)
	if not q.testMode then
		-- echo(q.sql)
	end
end

return _M

