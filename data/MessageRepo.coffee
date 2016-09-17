Message = require('./models/Message')


createNewMessage = (options, next) -> # todo: remove this if not used
    new Message(options)
        .save next

getConversationIdOfMessageById = (_message, next) -> # todo: remove this if not used
    Message.findById(_message)
    .select('_conversation')
    .exec (err, message) ->
        next(err, message?._conversation)

getMessagesForConversationIdLimitToNumBeforeDate = (_conversation, limitNum, date, next) -> # todo: remove this if not used
    Message.find({ _conversation: _conversation })
    .select('date content _user')
    .populate('_user', 'username')
    .where('date').lt(date)
    .sort({ date: -1 })
    .limit(limitNum)
    .exec next

getMessagesForConversationIdLimitToNum = (_conversation, limitNum, next) -> # todo: remove this if not used
    Message.find({ _conversation: _conversation })
    .select('date content _user')
    .populate('_user', 'username')
    .sort({ date: -1 })
    .limit(limitNum)
    .exec next

deleteByConversationId = (_conversation, next) -> # todo: remove this if not used
    Message.remove { _conversation: _conversation },
    next

deleteMessageById = (_message, next) -> # todo: remove this if not used
    Message.findByIdAndRemove _message, next

populateMessagesWithUsername = (messages, next) -> # todo: remove this if not used
    Message.populate messages, {
        path: '_user'
        select: 'username'
    }, next


module.exports = {
    createNewMessage: createNewMessage
    getConversationIdOfMessageById: getConversationIdOfMessageById
    getMessagesForConversationIdLimitToNumBeforeDate: getMessagesForConversationIdLimitToNumBeforeDate
    getMessagesForConversationIdLimitToNum: getMessagesForConversationIdLimitToNum
    deleteByConversationId: deleteByConversationId
    deleteMessageById: deleteMessageById
    populateMessagesWithUsername: populateMessagesWithUsername
}
