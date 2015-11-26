gulp         = require 'gulp'
$             = require('gulp-load-plugins')()

config = require '../config'


gulp.task 'sass-lint', ->
  sasslintConfig = {
      config : config.path.sasslintConfig
      customReport: $.scssLintStylish2().issues
    }
  if config.isJenkins
    sasslintConfig.reporterOutputFormat = 'Checkstyle'
    sasslintConfig.filePipeOutput = 'scssReport.xml'

  gulp
    .src config.path.sass
    .pipe $.if !config.isJenkins, $.plumber(config.ERROR_HANDLER)
    .pipe $.scssLint(sasslintConfig)
    .pipe $.scssLintStylish2().printSummary
    .pipe $.if config.isJenkins, gulp.dest config.outpath.lint


gulp.task 'sass', ->
    $.rubySass(config.path.sassroot,
      style: 'expanded'
      sourcemap: true
      defaultEncoding: 'utf-8'
      )
    .on 'error', (e) -> throw e
    .pipe $.pleeease(
              autoprefixer: config.AUTOPREFIXER_BROWSERS,
              minifier: false
      )
    .pipe $.if config.isRelease, $.minifyCss()
    .pipe $.sourcemaps.write(config.outpath.sourcemap,
      includeContent: false
      )
    .pipe gulp.dest config.outpath.css
