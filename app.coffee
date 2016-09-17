fs = require('fs')
express = require('express')
cors = require('cors')
app = express()
http = require('http').Server(app)
io = require('socket.io')(http)

mongoose = require('mongoose')
logger = require('morgan')
passport = require('passport')
cookieParser = require('cookie-parser')
bodyParser = require('body-parser')
session = require('express-session')

config = require('./config.json')

mongoose.connect(
    if process.env.dbAddress?
        process.env.dbAddress
    else
        config.dbAddress
)

app.use(logger('dev'))
app.use(cookieParser())
app.use(bodyParser.json())

app.use(session({
    secret: config.sessionSecret
    cookie: {
        maxAge: 30 * 60 * 1000
    }
    rolling: true
    resave: false
    saveUninitialized: false
}))

app.use(cors({ credentials: true, origin: true, methods: ['GET', 'PUT', 'POST', 'DELETE'], credentials: true }))

require('./passport')
app.use(passport.initialize())
app.use(passport.session())

router = require('./routes/router')(io)
app.use(router)

port = (process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 3000)
ip = process.env.OPENSHIFT_NODEJS_IP
app.set('port', port)
if ip?
    app.set('ip', ip)
    http.listen(port, ip)
else
    http.listen(port)

module.exports = http
