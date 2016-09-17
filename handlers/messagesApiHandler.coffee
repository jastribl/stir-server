MessageRepo = require('../data/MessageRepo')

numberOfMessagesToLoad = 30


module.exports = (io) ->

    addNewMessage = (req, res, next) -> # todo: remove this if not used
        _conversation = req.body._conversation

        MessageRepo.createNewMessage {
            date: new Date()
            _user: req.user._id
            _conversation: _conversation
            content: req.body.messageContent
        }, (err, newMessage) ->
            return next(err) if err
            MessageRepo.populateMessagesWithUsername newMessage, (err, populatedMessage) ->
                return next(err) if err
                io.sockets.in(_conversation).emit('newMessage', populatedMessage)
                res.sendStatus(201)

    deleteMessage = (req, res, next) -> # todo: remove this if not used
        _message = req.body._message

        MessageRepo.getConversationIdOfMessageById _message, (err, _conversation) ->
            return next(err) if err
            MessageRepo.deleteMessageById _message, (err) ->
                return next(err) if err
                io.sockets.in(_conversation).emit('removeMessage', _message)
                res.sendStatus(200)

    getInitialMessages = (req, res, next) -> # todo: remove this if not used
        MessageRepo.getMessagesForConversationIdLimitToNum req.body._conversation, numberOfMessagesToLoad, (err, messages) ->
            return next(err) if err
            res.json(messages)

    getMoreMessages = (req, res, next) -> # todo: remove this if not used
        MessageRepo.getMessagesForConversationIdLimitToNumBeforeDate req.body._conversation, numberOfMessagesToLoad, req.body.lastDate, (err, messages) ->
            return next(err) if err
            res.json(messages)

    {
        addNewMessage: addNewMessage
        deleteMessage: deleteMessage
        getInitialMessages: getInitialMessages
        getMoreMessages: getMoreMessages
    }
