gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
browserSync = require 'browser-sync'

config = require '../config'


gulp.task 'browser', ->
  browserSync.init
    server:
      baseDir: config.$WebContent

gulp.task 'brower-reload', ->
  browserSync.reload()