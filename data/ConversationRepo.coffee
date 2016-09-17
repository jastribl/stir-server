Conversation = require('./models/Conversation')


createNewConversation = (options, next) ->
    new Conversation(options)
        .save next

module.exports = {
    createNewConversation: createNewConversation
}
