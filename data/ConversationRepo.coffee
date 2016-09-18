Conversation = require('./models/Conversation')


createNewConversation = (options, next) ->
    new Conversation(options)
        .save next

getConversationById = (_conversation, next) ->
    Conversation.findById(_conversation)
    .exec next

getAllUnmergedConversationIds = (next) ->
    Conversation.find().distinct '_id', next


module.exports = {
    createNewConversation: createNewConversation
    getConversationById: getConversationById
    getAllUnmergedConversationIds: getAllUnmergedConversationIds
}
