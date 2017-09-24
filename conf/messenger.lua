
local conf = {
    models = {
        message = {
            model = '.app.model.message',
            table = 'messages',
        },
        participant = {
            model = '.app.model.participant',
            table = 'participants'
        },
        thread = {
            model = '.app.model.thread',
            table = 'threads'
        }
    }
}

return conf

