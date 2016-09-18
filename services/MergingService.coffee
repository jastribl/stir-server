ConversationRepo = require('../data/ConversationRepo')
UserRepo = require('../data/UserRepo')

class MergingServiceWorker
    constructor: (@conversationId) ->

    # todo: all errors not caught
    mergeWithConversationAndReturnNewConversation: (otherConversationId, callback) =>
        if @conversationId is otherConversationId
            return
        ConversationRepo.createNewConversation {
            _parents: [@conversationId, otherConversationId]
        }, (err, newConversation) =>
            ConversationRepo.getConversationById @conversationId, (err, conversation1) =>
                conversation1.isMerged = true
                conversation1.save (err) =>
                    ConversationRepo.getConversationById otherConversationId, (err, conversation2) =>
                        conversation2.isMerged = true
                        conversation2.save (err) =>
                            UserRepo.addConversationIdToUsersInConversationId conversation1._id, newConversation._id, (err) =>
                                UserRepo.addConversationIdToUsersInConversationId conversation2._id, newConversation._id, (err) =>
                                    callback(newConversation, @conversationId, otherConversationId)

    attemptMerging: (thing, callback) =>

        if thing == 'thing'
            # todo: algorithm
            ConversationRepo.getAllConversationIds (err, allIds) =>
                for id in allIds
                    if JSON.parse(JSON.stringify(id)) != JSON.parse(JSON.stringify(@conversationId))
                        @mergeWithConversationAndReturnNewConversation JSON.parse(JSON.stringify(id)), callback
                        return

getNewMergingServiceWorker = (conversationId) ->
    new MergingServiceWorker(conversationId)

module.exports = {
    getNewMergingServiceWorker: getNewMergingServiceWorker
}
