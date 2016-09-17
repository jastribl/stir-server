express = require('express')

module.exports = express.Router()
    .get '/test', (req, res, next) ->
        res.send 'Hello World!'
