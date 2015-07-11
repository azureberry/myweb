gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
# bowerfiles  = require 'main-bower-files'
runSequence = require 'run-sequence'
config = require 'config'


karma = require('karma').server



gulp.task 'karma', ->
  karma.start {configFile: config.test.karma}

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


gulp.task 'test', (callback) ->
  runSequence(
    'webserver-start'
    'protractor'
    )
