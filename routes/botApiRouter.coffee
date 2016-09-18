express = require('express')
Cleverbot = require('cleverbot-node')


module.exports = express.Router()

    .post '/reply', (req, rs, next) ->
        message = req.body.message

        cleverbot = new Cleverbot()

        Cleverbot.prepare ->
            cleverbot.write message, (botRes) ->
                res.send(botRes)
