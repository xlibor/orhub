
local lx, _M, mt = oo{
    _cls_ = '',
    _ext_ = 'controller'
}

local app, lf, tb, str = lx.kit()

function _M:ctor()

    self:middleware('auth')
end

function _M:index()

    local threads = Thread.participateBy(Auth.id())
    if Auth.user():newThreadsCount() == 0 then
        Auth.user().message_count = 0
        Auth.user():save()
    end
    
    return view('messages.index', Compact('threads', 'currentUserId'))
end

function _M:show(id)

    local thread = Thread.findOrFail(id)
    local participant = thread:participant()
    local messages = thread:messages():recent():get()
    self:authorize('show', thread)
    -- counters
    local unread_message_count = thread:userUnreadMessagesCount(Auth.id())
    if unread_message_count > 0 then
        Auth.user().message_count = Auth.user().message_count - unread_message_count
        Auth.user():save()
    end
    thread:markAsRead(Auth.id())
    
    return view('messages.show', Compact('thread', 'participant', 'messages', 'unread_message_count'))
end

function _M:create(id)

    local recipient = User.findOrFail(id)
    local thread = Thread.between({recipient.id, Auth.id()}):first()
    if thread then
        
        return redirect():route('messages.show', thread.id)
    end
    
    return view('messages.create', Compact('recipient'))
end

function _M:store(request, markdown)

    local thread
    local recipient = User.findOrFail(request.recipient_id)
    if request.thread_id then
        thread = Thread.findOrFail(request.thread_id)
    else 
        subject = Auth.user().name .. ' 给 ' .. recipient.name .. ' 的私信。'
        thread = Thread.create({subject = subject})
    end
    -- Message
    local message = markdown:convertMarkdownToHtml(request.message)
    Message.create({thread_id = thread.id, user_id = Auth.id(), body = message})
    -- Sender
    local participant = Participant.firstOrCreate({thread_id = thread.id, user_id = Auth.id()})
    participant.last_read = new('carbon')
    participant:save()
    -- Recipient
    thread:addParticipant(recipient.id)
    -- Notify user by Email
    local job = (new('sendNotifyMail', 'new_message', Auth.user(), recipient, nil, nil, message)):delay(config('lxhub.notifyDelay'))
    dispatch(job)
    -- notifications count
    recipient.message_count = recipient.message_count + 1
    recipient:save()
    
    return redirect():route('messages.show', thread.id)
end

return _M

