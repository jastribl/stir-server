mongoose = require('mongoose')
Schema = mongoose.Schema
bcrypt = require('bcrypt-nodejs')


conversationSchema = new Schema({
    _parents: [{ type: Schema.Types.ObjectId, ref: 'conversation' }]
    _members: [{ type: Schema.Types.ObjectId, ref: 'user' }]
    isMerged: { type: Boolean, default: false }
})

module.exports = mongoose.model('conversation', conversationSchema)
