UserRepo = require('../data/UserRepo')
ConversationRepo = require('../data/ConversationRepo')

createNewConversation = (req, res, next) ->
    _user = req.user._id
    otherUserName = req.body.otherUserName
    UserRepo.getUserByUserName otherUserName, (err, user) ->
        return next(err) if err
        ConversationRepo.createNewConversation {
            _parents: []
            _members: [_user, user._id]
        }, (err) ->
            return next(err) if err
            res.send(200)

getConversations = (req, res, next) ->
    _user = req.user._id
    UserRepo.getConversationIdsFromUserWithId _user, (err, user) ->
        return next(err) if err
        res.send(user['_conversations'])


module.exports = {
    createNewConversation: createNewConversation
    getConversations: getConversations
}
