UserRepo = require('../data/UserRepo')
ConversationRepo = require('../data/ConversationRepo')

createNewConversation = (req, res, next) ->
    _user = req.user._id
    otherUserName = req.body.otherUserName
    UserRepo.getUserByUserName otherUserName, (err, user) ->
        return next(err) if err
        unless user?
            return res.sendStatus(400, 'error, this user does not exist')
        ConversationRepo.createNewConversation {
            _parents: []
            _members: [_user, user._id]
        }, (err, newConversation) ->
            return next(err) if err
            UserRepo.addConversationToUser _user, newConversation._id, (err) ->
                return next(err) if err
                UserRepo.addConversationToUser user._id, newConversation._id, (err) ->
                    return next(err) if err
                    res.sendStatus(200)

getConversations = (req, res, next) ->
    _user = req.user._id
    UserRepo.getConversationIdsFromUserWithId _user, (err, user) ->
        return next(err) if err
        res.send(user['_conversations'])


module.exports = {
    createNewConversation: createNewConversation
    getConversations: getConversations
}
