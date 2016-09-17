express = require('express')

conversationApiHandler = require('../handlers/conversationApiHandler')

module.exports = express.Router()
    .get '/all', conversationApiHandler.getConversations
