Message = require('./models/Message')


createNewMessage = (options, next) ->
    new Message(options)
        .save next

getMessagesForConversationId = (_conversation, next) ->
    Message.find({ _conversation: _conversation })
    .select('date content _user')
    .populate('_user', 'username')
    .sort({ date: 1 })
    .exec next

populateMessagesWithUsername = (messages, next) ->
    Message.populate messages, {
        path: '_user'
        select: 'username'
    }, next


module.exports = {
    createNewMessage: createNewMessage
    getMessagesForConversationId: getMessagesForConversationId
    populateMessagesWithUsername: populateMessagesWithUsername
}
