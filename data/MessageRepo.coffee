Message = require('./models/Message')


createNewMessage = (options, next) ->
    new Message(options)
        .save next

getConversationIdOfMessageById = (_message, next) ->
    Message.findById(_message)
    .select('_conversation')
    .exec (err, message) ->
        next(err, message?._conversation)

getMessagesForConversationIdBeforeDate = (_conversation, date, next) ->
    Message.find({ _conversation: _conversation })
    .select('date content _user')
    .populate('_user', 'username')
    .where('date').lt(date)
    .sort({ date: 1 })
    .exec next

getMessagesForConversationId = (_conversation, next) ->   # todo: fix naming
    Message.find({ _conversation: _conversation })
    .select('date content _user')
    .populate('_user', 'username')
    .sort({ date: 1 })
    .exec next

deleteMessageById = (_message, next) ->
    Message.findByIdAndRemove _message, next

populateMessagesWithUsername = (messages, next) ->
    Message.populate messages, {
        path: '_user'
        select: 'username'
    }, next


module.exports = {
    createNewMessage: createNewMessage
    getConversationIdOfMessageById: getConversationIdOfMessageById
    getMessagesForConversationIdBeforeDate: getMessagesForConversationIdBeforeDate
    getMessagesForConversationId: getMessagesForConversationId
    deleteMessageById: deleteMessageById
    populateMessagesWithUsername: populateMessagesWithUsername
}
