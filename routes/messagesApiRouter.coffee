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
                        console.log 'merging: ', _oldConversation1, 'with: ', _oldConversation2
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
                        MessageRepo.getMessagesForConversationId _oldConversation1, (err, messages) ->
                            io.sockets.in("user_#{req.user._id}").emit('newMessages', _oldConversation1, messages)
                        MessageRepo.getMessagesForConversationId _oldConversation2, (err, messages) ->
                            io.sockets.in("user_#{req.user._id}").emit('newMessages', _oldConversation2, messages)
