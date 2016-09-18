Conversation = require('./models/Conversation')


createNewConversation = (options, next) ->
    new Conversation(options)
        .save next

getConversationById = (_conversation, next) ->
    Conversation.findById(_conversation)
    .exec next

getAllConversationIdsWhereNotGiven = (_dontGetId, next) ->
    Conversation.find({ _id: { '$ne': _dontGetId } }).distinct '_id', next


module.exports = {
    createNewConversation: createNewConversation
    getConversationById: getConversationById
    getAllConversationIdsWhereNotGiven: getAllConversationIdsWhereNotGiven
}
