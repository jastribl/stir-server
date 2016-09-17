User = require('./models/User')


createNewUser = (options, next) ->
    newUser = new User(options)
        .encryptPassword()
        .save next

getUserById = (_user, next) ->
    User.findById _user, next

getUserByUserName = (username, next) ->
    User.findOne { username: username },
    next

getConversationIdsFromUserWithId = (_user, next) ->
    User.findById(_user)
    .select('_conversations')
    .exec next

addConversationToUser = (_user, _conversation, next) ->
    User.findByIdAndUpdate _user,
    { $push: { _conversations: _conversation } },
    next

removeConversationFromUser = (_conversation, _user, next) ->
    User.findByIdAndUpdate _user,
    { $pull: { _conversations: _conversation } },
    next

module.exports = {
    createNewUser: createNewUser
    getUserById: getUserById
    getUserByUserName: getUserByUserName
    getConversationIdsFromUserWithId: getConversationIdsFromUserWithId
    addConversationToUser: addConversationToUser
    removeConversationFromUser: removeConversationFromUser
}
