express = require('express')

MessageRepo = require('../data/MessageRepo')

numberOfMessagesToLoad = 30


module.exports = (io) ->

    messagesApiHandler = require('../handlers/messagesApiHandler')(io)

    express.Router()
        .post '/new', messagesApiHandler.addNewMessage
        .post '/delete', messagesApiHandler.deleteMessage
        .post '/getMore', messagesApiHandler.getMoreMessages
