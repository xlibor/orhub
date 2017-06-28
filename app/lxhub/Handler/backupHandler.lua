
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'baseSender'
}

local app, lf, tb, str = lx.kit()

function _M:new()

    local this = {
        client = nil
    }
    
    return oo(this, mt)
end

function _M:ctor(client)

    self.client = client
end

function _M:send()

    local data = {}
    data['text'] = self.subject
    data['color'] = '#E65128'
    tapd(data['attachments'], {text = self.message})
    self.client:request('POST', config('services.bearychat.hook'), {form_params = {payload = lf.jsen(data)}})
end

return _M

