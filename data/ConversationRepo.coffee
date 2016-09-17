Conversation = require('./models/Conversation')


createNewConversation = (options, next) ->
    new Conversation(options)
        .save next

getConversationById = (_conversation, next) ->
    Conversation.findById(_conversation)
    .exec next

getAllConversationIds = (next) ->
    Conversation.find().distinct '_id', next

getConversationMembersById = (_conversation, next) ->
    Conversation.findById(_conversation)
    .select('_members')
    .exec (err, conversation) ->
        next(err, conversation?._members)


module.exports = {
    createNewConversation: createNewConversation
    getConversationById: getConversationById
    getAllConversationIds: getAllConversationIds
    getConversationMembersById: getConversationMembersById
}
