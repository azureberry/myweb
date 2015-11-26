requireDir = require 'require-dir'
requireDir "./gulp/tasks", { recurse: true }

gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
runSequence = require 'run-sequence'

config = require './gulp/config'


gulp.task 'default', ['browser', 'watch']

gulp.task 'lint', ->  runSequence(
    'sass-lint'
    ['js-lint'
    'yml-lint'
    ])

gulp.task 'build', -> runSequence(
  'bower',
  ['js',
  'sass',
  'yml',
  'img',
  'link'],
  'jade'
)


gulp.task 'test', (callback) ->
  runSequence(
    'webserver-start'
    'protractor'
    callback
    )

# gulp.task 'deploy', -> #tasksに移動
