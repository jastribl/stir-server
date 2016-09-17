Conversation = require('./models/Conversation')


createNewConversation = (options, next) ->
    new Conversation(options)
        .save next

populateConversationMembersDisplayInfo = (conversations, next) -> # todo: remove this if not used
    Conversation.populate conversations, {
        path: '_members'
        select: 'username'
    }, next

updateConversationProperties = (conversation, next) -> # todo: remove this if not used
    Conversation.findByIdAndUpdate conversation._id,
    { $set: conversation },
    next

deleteConversationById = (_conversation, next) -> # todo: remove this if not used
    Conversation.findByIdAndRemove _conversation, next

addMemberToConversation = (_conversation, _member, next) -> # todo: remove this if not used
    Conversation.findByIdAndUpdate _conversation,
    { $addToSet: { _members: _member } },
    next

removeMemberFromConversation = (_conversation, _member, next) -> # todo: remove this if not used
    Conversation.findByIdAndUpdate _conversation,
    { $pull: { _members: _member } },
    next

getConversationMembersById = (_conversation, next) -> # todo: remove this if not used
    Conversation.findById(_conversation)
    .select('_members')
    .exec (err, conversation) ->
        next(err, conversation?._members)


module.exports = {
    createNewConversation: createNewConversation
    populateConversationMembersDisplayInfo: populateConversationMembersDisplayInfo
    updateConversationProperties: updateConversationProperties
    deleteConversationById: deleteConversationById
    addMemberToConversation: addMemberToConversation
    removeMemberFromConversation: removeMemberFromConversation
    getConversationMembersById: getConversationMembersById
}
