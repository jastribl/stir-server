express = require('express')

conversationApiHandler = require('../handlers/conversationApiHandler')

module.exports = express.Router()
    .post '/new', conversationApiHandler.createNewConversation
    .get '/all', conversationApiHandler.getConversations
