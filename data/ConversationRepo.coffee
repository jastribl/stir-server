Conversation = require('./models/Conversation')


createNewConversation = (options, next) ->
    new Conversation(options)
        .save next

getConversationById = (_conversation, next) ->
    Conversation.findById(_conversation)
    .exec next

getAllConversationsWhereIdNotGiven = (_dontGetId, next) ->
    Conversation.find({ _id: { '$ne': _dontGetId } })
    .exec next


module.exports = {
    createNewConversation: createNewConversation
    getConversationById: getConversationById
    getAllConversationsWhereIdNotGiven: getAllConversationsWhereIdNotGiven
}
