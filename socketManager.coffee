UserRepo = require('./data/UserRepo')
ConversationRepo = require('./data/ConversationRepo')

module.exports = (io) ->

    io.on 'connection', (socket) ->

        socket.on 'conversationSubscribe', (user) ->
            socket.user = user
            _user = user._id
            UserRepo.getConversationIdsFromUserWithId _user, (err, populatedUser) ->
                if !err
                    socket.emit('allConversationIds', populatedUser['_conversations'])

        socket.on 'conversationConnect', (_conversation) ->
            ConversationRepo.getConversationMembersById _conversation, (err, _members) ->
                if not err and _members? and _members.indexOf(socket.user._id) isnt -1
                    socket.join(_conversation)
