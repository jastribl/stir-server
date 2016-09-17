express = require('express')

module.exports = (io) ->

    conversationsApiRouter = require('./conversationsApiRouter')
    messagesApiRouter = require('./messagesApiRouter')(io)

    return express.Router()
        .use('/conversations', conversationsApiRouter)
        .use('/messages', messagesApiRouter)
