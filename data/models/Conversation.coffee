mongoose = require('mongoose')
Schema = mongoose.Schema
bcrypt = require('bcrypt-nodejs')


conversationSchema = new Schema({
    username: String
    password: String
    _members: [{ type: Schema.Types.ObjectId, ref: 'user' }]
})

module.exports = mongoose.model('conversation', conversationSchema)
