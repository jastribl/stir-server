UserRepo = require('../data/UserRepo')


getConversations = (req, res, next) ->
    console.log 'wef'
    _user = req.user._id
    UserRepo.getConversationIdsFromUserWithId _user, (err, user) ->
        return next(err) if err
        user['_conversations']


module.exports = {
    getConversations: getConversations
}
