gulp = require('gulp')
coffeelint = require('gulp-coffeelint')
nodemon = require('gulp-nodemon')

passportSrcPath = './passport.coffee'
appSrcPath = './app.coffee'
dataSrcPath = './data/**/*.coffee'
routesSrcPath = './routes/**/*.coffee'
serverSpecSrc = './spec/server/**/*.spec.coffee'
allServerCoffeeFiles = [passportSrcPath, appSrcPath, dataSrcPath, routesSrcPath, serverSpecSrc]

gulp.task 'coffeelint', ->
    gulp.src(allServerCoffeeFiles)
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())

gulp.task 'dev', ->
    nodemon({
        script: 'server.coffee'
    })
