request = require('request')

MeaningCloud = require('meaning-cloud')

_ = require('lodash-node')

config = require('../config.json')

ConversationRepo = require('../data/ConversationRepo')
UserRepo = require('../data/UserRepo')
MessageRepo = require('../data/MessageRepo')


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

    getResults: (text, callback) ->
        options =
            method: 'POST'
            url: "#{config.meaningCloudApiPath}/topics-2.0"
            headers: 'content-type': 'application/x-www-form-urlencoded'
            form:
                key: config.meaningCloudLicenseKey
                lang: 'en'
                txt: text
                tt: 'ec'

        request options, (error, response, body) ->
            result = if error then null else body
            if result
                all_key_words = []
                result = JSON.parse(result)
                if result.entity_list
                    all_key_words = (entity.form for entity in result.entity_list)
                if result.concept_list
                    all_key_words = all_key_words.concat (concept.form for concept in result.concept_list)
                callback(all_key_words)
            else
                console.log 'result null'

    attemptMerging: (callback) =>
        MessageRepo.getMessagesForConversationId @conversationId, (err, myMessages) =>
            unless err
                myThing = ""
                myThing += "#{message.content} " for message in myMessages
                unless myThing is ""
                    @getResults myThing, (myResult) =>
                        console.log 'myResult', myResult
                        if myResult
                            found_match = false
                            ConversationRepo.getAllConversationsWhereIdNotGiven @conversationId, (err, allConversations) =>
                                # console.log allConversations
                                for convo in allConversations
                                    unless found_match or convo.isMerged isnt true
                                        MessageRepo.getMessagesForConversationId convo._id, (err, messages) =>
                                            unless err
                                                thing = ""
                                                thing += "#{message.content} " for message in messages
                                                unless thing is ""
                                                    @getResults thing, (result) =>
                                                        console.log 'result', result
                                                        if result
                                                            if _.intersection(myResult, result).length > 0
                                                                console.log 'intercected on: _.intersection(myResult, result)'
                                                                found_match = true
                                                                @mergeWithConversationAndReturnNewConversation JSON.parse(JSON.stringify(convo._id)), callback

getNewMergingServiceWorker = (conversationId) ->
    new MergingServiceWorker(conversationId)

module.exports = {
    getNewMergingServiceWorker: getNewMergingServiceWorker
}
