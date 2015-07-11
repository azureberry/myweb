gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
# bowerfiles  = require 'main-bower-files'
# runSequence = require 'run-sequence'
config = require 'config'


# gulp.task 'json', ->
#   gulp
#     .src config.path.jsondata
#     .pipe $.jsonlint()
#     .pipe $.jsonlint.reporter()

gulp.task 'yml-lint', ->
  gulp
    .src config.path.yml
    .pipe $.plumber(ERROR_HANDLER)
    .pipe $.yamlValidate({safe : true})

gulp.task 'yml', ->
  gulp
    .src config.path.yml
    .pipe $.plumber(ERROR_HANDLER)
    .pipe $.concat(configFileName+'.yml')
    .pipe $.convert(
              from: 'yml',
              to: 'json')
    .pipe gulp.dest config.path.json

gulp.task 'jade', ->
  gulp
    .src config.path.jadetask
    .pipe $.plumber(ERROR_HANDLER)
    .pipe $.jade(
              data: require(config.path.jsondata)
              pretty: true
      )
#    .pipe $.htmlhint()
    .pipe $.if isRelease, $.minifyHtml()
    .pipe gulp.dest config.outpath.html
    .pipe $.if isRelease, $.sitemap(siteUrl: mySiteUrl)
    .pipe $.if isRelease, gulp.dest config.outpath.html
