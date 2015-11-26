gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
webpack = require 'webpack-stream'

config = require '../config'


gulp.task 'js-lint', ->
  tempfunc = console.log
  if config.isJenkins
    fs = require('fs')
    log_file = fs.createWriteStream(config.outpath.lint + '/coffeelint.xml', {flags : 'w'})
    console.log = (d) ->
      log_file.write d.replace(/[\u001b\u009b][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]/g, '') + '\n'

  gulp
    .src config.path.js
    .pipe $.if !config.isJenkins, $.plumber(config.ERROR_HANDLER)
    .pipe $.coffeelint(optFile: config.path.jslintConfig)
    .pipe $.if !config.isJenkins, $.coffeelint.reporter(), $.coffeelint.reporter('checkstyle')
    .on 'end', -> $.if config.isJenkins, console.log = tempfunc

gulp.task 'js', ->
  gulp
    .src config.path.js
    .pipe $.if !config.isJenkins, $.plumber(config.ERROR_HANDLER)
    .pipe webpack require(config.path.webpack)
    .pipe $.if config.isRelease, $.uglify()
    .pipe gulp.dest config.outpath.js