gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
# bowerfiles  = require 'main-bower-files'
# runSequence = require 'run-sequence'
config = require 'config'

browserSync = require 'browser-sync'


gulp.task 'browser', ->
  browserSync.init
    server:
      baseDir: $WebContent

gulp.task 'brower-reload', ->
  browserSync.reload()