gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
# bowerfiles  = require 'main-bower-files'
# runSequence = require 'run-sequence'
config = require './config.coffee'

gulp.task 'js-lint', ->
  gulp
    .src config.path.js
    .pipe $.plumber(ERROR_HANDLER)
    .pipe $.coffeelint(config.path.jslintConfig)
    .pipe $.coffeelint.reporter()

gulp.task 'js', ->
  gulp
    .src config.path.js
    .pipe $.plumber(ERROR_HANDLER)
    .pipe $.webpack require(config.path.webpack)
    .pipe $.if isRelease, $.uglify()
    .pipe gulp.dest config.outpath.js
