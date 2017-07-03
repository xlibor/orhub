
local lx, _M, mt = oo{
	_cls_	= ''
}

local app, lf, tb, str = lx.kit()

function _M:new()

	return oo({}, mt)
end

function _M:handle(e, model)

	local event, model = e.name, e.sender

	local handler = self[event]
	if handler then
		handler(self, model)
	end

	-- echo(model.__nick)
end

function _M:creating(model)
 
end

function _M:created(model)

end

function _M:updating(model)
 
end

function _M:updated(model)
 
end

function _M:deleting(model)

end

function _M:deleted(model)

end

function _M:saving(model)
 
end

function _M:saved(model)

end

function _M:restoring(model)

end

function _M:restored(model)

end

return _M

