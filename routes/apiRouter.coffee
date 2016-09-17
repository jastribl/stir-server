express = require('express')

module.exports = (io) ->

    conversationsApiRouter = require('./conversationsApiRouter')

    return express.Router()
        .use('/conversations', conversationsApiRouter)
