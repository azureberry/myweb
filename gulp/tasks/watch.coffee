gulp         = require 'gulp'
$             = require('gulp-load-plugins')()

config = require '../config'


gulp.task 'watch', ->
  $.watch config.path.js, ->gulp.start ['js','brower-reload']
  $.watch config.path.sass, ->gulp.start ['sass','brower-reload']
  $.watch [config.path.yml], ->gulp.start ['yml']
  $.watch [config.path.jade, config.path.jsondata], ->gulp.start ['jade','brower-reload']
  $.watch config.path.img, ->gulp.start ['img','brower-reload']
  $.watch config.path.link, ->gulp.start ['link','brower-reload']
