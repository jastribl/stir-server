UserRepo = require('./data/UserRepo')
MessageRepo = require('./data/MessageRepo')
ConversationRepo = require('./data/ConversationRepo')
User = require('./data/models/User') # todo get this out of here
Conversation = require('./data/models/Conversation') # todo get this out of here

module.exports = (io) ->

    io.on 'connection', (socket) ->

        socket.on 'conversationSubscribe', (user) ->
            socket.user = user
            _user = user._id
            socket.join("user_#{_user}")
            User.findById(_user)        # todo: fix this
            .select('_conversations')
            .populate('_conversations')
            .exec (err, populatedUser) ->
                console.log populatedUser._conversations
                if err
                    socket.emit('error')
                else
                    socket.emit('allConversationIds', conversations)

        socket.on 'conversationConnect', (_conversation) ->
            UserRepo.getConversationIdsFromUserWithId socket.user._id, (err, myUser) ->
                if not err and myUser._conversations? and myUser._conversations.indexOf(_conversation) isnt -1
                    socket.join(_conversation)
                    MessageRepo.getMessagesForConversationIdLimitToNum _conversation, (err, messages) ->
                        if err
                            socket.emit('error')
                        else
                            socket.emit('newMessages', _conversation, messages)
