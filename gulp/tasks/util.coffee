gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
wiredep = require('wiredep').stream

config = require '../config'


gulp.task "wiredep", ->
  gulp
    .src config.path.sass
    .pipe wiredep()
    .pipe gulp.dest $src + '/scss/'


# gulp.task 'json2yml', ->
#   gulp.src config.path.jsondata
#    .pipe $.convert(
#       from: 'json',
#       to: 'yml')
#    .pipe gulp.dest $src + '/json'
