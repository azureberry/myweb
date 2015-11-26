gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
# karma = require('karma').server

config = require '../config'


# gulp.task 'karma', ->
#   karma.start {configFile: config.test.karma}

gulp.task 'webserver-start', ->
  gulp.src('./WebContent')
  .pipe $.webserver
    host: config.test.host
    port: config.test.port

gulp.task 'protractor', ->
  gulp.src([config.test.spec])
    .pipe $.protractor.protractor(
      configFile: config.test.protractor
      args: ['--baseUrl', 'http://'+config.test.host+':'+config.test.port]
      )
    .on 'end', -> process.exit()
    .on 'error', (e) -> throw e
