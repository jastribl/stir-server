ConversationRepo = require('../data/ConversationRepo')

class MergingServiceWorker
    constructor: (@conversationId) ->

    # todo: all errors not caught
    mergeWithConversationAndReturnNewConversation: (otherConversationId, next) =>
        console.log "merging #{@conversation} and #{otherConversationId}"
        ConversationRepo.getConversationById @conversationId, (err, conversation1) =>
            ConversationRepo.getConversationById otherConversationId, (err, conversation2) =>
                conversation1.isMerged = true
                conversation2.isMerged = true
                ConversationRepo.createNewConversation {
                    _parents: [@conversationId, otherConversationId]
                    _members: conversation1._members.concat(conversation2._members)
                    isMerged: true
                }, (err, newConversation) =>
                    conversation1.save (err) =>
                        conversation2.save (err) =>
                            UserRepo.removeConversationFromUser (@conversationId, otherConversationId) =>
                                UserRepo.removeConversationFromUser
                            next(newConversation)

    attemptMerging: =>
        console.log "attempting to merge conversation #{@conversationId}"
        ConversationRepo.getAllConversationIds (err, allIds) =>
            for  id in allIds
                ran = Math.random() * (10 - 1) + 1
                if ran is 3
                    @mergeWithConversationAndReturnNewConversation id, (newConversation) ->


        # todo: algorithm

getNewMergingServiceWorker = (conversationId) ->
    new MergingServiceWorker(conversationId)

module.exports = {
    getNewMergingServiceWorker: getNewMergingServiceWorker
}