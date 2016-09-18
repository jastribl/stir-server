UserRepo = require('./data/UserRepo')
MessageRepo = require('./data/MessageRepo')
ConversationRepo = require('./data/ConversationRepo')

numberOfMessagesToLoad = 30

module.exports = (io) ->

    io.on 'connection', (socket) ->

        socket.on 'conversationSubscribe', (user) ->
            socket.user = user
            _user = user._id
            socket.join("user_#{_user}")
            UserRepo.getConversationIdsFromUserWithId _user, (err, populatedUser) ->
                if err
                    socket.emit('error')
                else
                    socket.emit('allConversationIds', populatedUser['_conversations'])

        socket.on 'conversationConnect', (_conversation) ->
            UserRepo.getConversationIdsFromUserWithId socket.user._id, (err, myUser) ->
                if not err and myUser._conversations? and myUser._conversations.indexOf(_conversation) isnt -1
                    socket.join(_conversation)
                    MessageRepo.getMessagesForConversationIdLimitToNum _conversation, numberOfMessagesToLoad, (err, messages) ->
                        if err
                            socket.emit('error')
                        else
                            socket.emit('newMessages', _conversation, messages)
