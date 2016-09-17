express = require('express')

module.exports = (io) ->

    testsApiRouter = require('./testsApiRouter')

    return express.Router()
        .use('/tests', testsApiRouter)
