express = require('express')

UserRepo = require('../data/UserRepo')
ConversationRepo = require('../data/ConversationRepo')


module.exports = (io) ->

    express.Router()

        .post '/new', (req, res, next) ->
            _user = req.user._id
            otherUserName = req.body.otherUserName
            UserRepo.getUserByUserName otherUserName, (err, user) ->
                return next(err) if err
                unless user?
                    return res.sendStatus(400, 'error, this user does not exist')
                ConversationRepo.createNewConversation {
                    _parents: []
                }, (err, newConversation) ->
                    return next(err) if err
                    UserRepo.addConversationToUser _user, newConversation._id, (err) ->
                        return next(err) if err
                        UserRepo.addConversationToUser user._id, newConversation._id, (err) ->
                            return next(err) if err
                            res.send(200, {
                                'conversation_id': newConversation._id
                            })
                            io.sockets.in("user_#{_user}").emit('newConversation', newConversation)
                            io.sockets.in("user_#{user._id}").emit('newConversation', newConversation)

        .get '/all', (req, res, next) ->
            _user = req.user._id
            UserRepo.getConversationIdsFromUserWithId _user, (err, user) ->
                return next(err) if err
                res.send(user['_conversations'])
