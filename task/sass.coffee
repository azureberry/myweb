gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
# bowerfiles  = require 'main-bower-files'
# runSequence = require 'run-sequence'
config = require 'config'


wiredep = require('wiredep').stream

gulp.task 'sass-lint', ->
  gulp
    .src config.path.sass
    .pipe $.plumber(ERROR_HANDLER)
    .pipe $.scssLint(
      config : config.path.sasslintConfig
      customReport: $.scssLintStylish2().issues
    )
    .pipe $.scssLintStylish2().printSummary

gulp.task 'sass', ->
    $.rubySass(config.path.sassroot,
      style: 'expanded'
      sourcemap: true
      )
    .on 'error', (e) -> throw e
    .pipe $.pleeease(
              autoprefixer: AUTOPREFIXER_BROWSERS,
              minifier: false
      )
    .pipe $.if isRelease, $.minifyCss()
    .pipe $.sourcemaps.write(config.outpath.sourcemap,
      includeContent: false
      )
    .pipe gulp.dest config.outpath.css

gulp.task "wiredep", ->
  gulp
    .src config.path.sass
    .pipe wiredep()
    .pipe gulp.dest $src + '/scss/'