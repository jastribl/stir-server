express = require('express')

module.exports = (io) ->

    conversationsApiRouter = require('./conversationsApiRouter')(io)
    messagesApiRouter = require('./messagesApiRouter')(io)
    botApiRouter = require('./botApiRouter')

    return express.Router()
        .use('/conversations', conversationsApiRouter)
        .use('/messages', messagesApiRouter)
        .use('/bot', botApiRouter)
