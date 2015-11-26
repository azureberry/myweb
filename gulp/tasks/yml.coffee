gulp         = require 'gulp'
$             = require('gulp-load-plugins')()

config = require '../config'


gulp.task 'yml-lint', ->
  gulp
    .src config.path.yml
    .pipe $.if !config.isJenkins, $.plumber(config.ERROR_HANDLER)
    .pipe $.yamlValidate({safe : true})

gulp.task 'yml', ->
  gulp
    .src config.path.yml
    .pipe $.if !config.isJenkins, $.plumber(config.ERROR_HANDLER)
    .pipe $.concat(config.configFileName+'.yml')
    .pipe $.convert(
              from: 'yml',
              to: 'json')
    .pipe gulp.dest config.path.json