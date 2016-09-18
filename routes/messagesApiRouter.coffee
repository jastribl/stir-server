express = require('express')

MessageRepo = require('../data/MessageRepo')
MergingService = require('../services/MergingService')

numberOfMessagesToLoad = 30


module.exports = (io) ->

    express.Router()

        .post '/new', (req, res, next) ->
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
                    io.sockets.in(_conversation).emit('newMessages', _conversation, [populatedMessage])
                    res.sendStatus(201)
                    MergingService.getNewMergingServiceWorker(_conversation).attemptMerging (newConversation, _oldConversation1, _oldConversation2) ->
                        io.sockets.in(_oldConversation1).emit('mergeNotification', {
                            _oldConversation1: _oldConversation1
                            _oldConversation2: _oldConversation2
                            newConversation: newConversation
                        })
                        io.sockets.in(_oldConversation2).emit('mergeNotification', {
                            _oldConversation1: _oldConversation1
                            _oldConversation2: _oldConversation2
                            newConversation: newConversation
                        })
                        MessageRepo.getMessagesForConversationIdLimitToNum _oldConversation1, (messages) ->
                            io.sockets.in("user_#{req.user._id}").emit('newMessages', _oldConversation1, messages)
                        MessageRepo.getMessagesForConversationIdLimitToNum _oldConversation2, (messages) ->
                            io.sockets.in("user_#{req.user._id}").emit('newMessages', _oldConversation2, messages)

        .post '/delete', (req, res, next) -> # todo: remove this if not used
            _message = req.body._message

            MessageRepo.getConversationIdOfMessageById _message, (err, _conversation) ->
                return next(err) if err
                MessageRepo.deleteMessageById _message, (err) ->
                    return next(err) if err
                    io.sockets.in(_conversation).emit('removeMessage', _message)
                    res.sendStatus(200)

        .post '/getMore', (req, res, next) -> # todo: remove this if not used
            MessageRepo.getMessagesForConversationIdLimitToNumBeforeDate req.body._conversation, numberOfMessagesToLoad, req.body.lastDate, (err, messages) ->
                return next(err) if err
                res.json(messages)
