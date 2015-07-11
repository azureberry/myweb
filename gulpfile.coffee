gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
bowerfiles  = require 'main-bower-files'
runSequence = require 'run-sequence'
#manifest     = require('asset-builder')('./manifest.json')
requireDir = require('require-dir')
dir        = requireDir('./task')


gulp.task 'json2yml', ->
  gulp.src config.path.jsondata
   .pipe $.convert(
      from: 'json',
      to: 'yml')
   .pipe gulp.dest $src + '/json'

gulp.task 'watch', ->
  $.watch config.path.js, ->gulp.start ['js','brower-reload']
  $.watch config.path.sass, ->gulp.start ['sass','brower-reload']
  $.watch [config.path.yml], ->gulp.start ['yml']
#  $.watch [config.path.json], ->gulp.start ['json','jade']
  $.watch [config.path.jade, config.path.jsondata], ->gulp.start ['jade','brower-reload']
  $.watch config.path.img, ->gulp.start ['img','brower-reload']
  $.watch config.path.link, ->gulp.start ['link','brower-reload']


gulp.task 'default', ['browser', 'watch']
gulp.task 'build', -> runSequence(
  'bower',
  ['js',
  'sass',
#  'json',
  'yml'],
  'jade',
  ['img',
  'link'],
)
