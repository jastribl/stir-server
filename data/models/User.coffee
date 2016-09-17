mongoose = require('mongoose')
Schema = mongoose.Schema
bcrypt = require('bcrypt-nodejs')


userSchema = new Schema({
    username: String
    password: String
})

userSchema.methods.encryptPassword = ->
    @password = bcrypt.hashSync(@password, bcrypt.genSaltSync(8), null)
    @

userSchema.methods.validPassword = (password) ->
    bcrypt.compareSync(password, @password)

module.exports = mongoose.model('user', userSchema)
