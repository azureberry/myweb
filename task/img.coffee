gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
# bowerfiles  = require 'main-bower-files'
# runSequence = require 'run-sequence'
config = require 'config'


gulp.task 'img', ->
  gulp
    .src config.path.img
#    .pipe $.plumber()
    .pipe gulp.dest config.outpath.img

gulp.task 'link', ->
  gulp
    .src config.path.link
#    .pipe $.plumber()
    .pipe gulp.dest config.outpath.link
