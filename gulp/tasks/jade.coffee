gulp         = require 'gulp'
$             = require('gulp-load-plugins')()

config = require '../config'


gulp.task 'jade', ->
  gulp
    .src config.path.jadetask
    .pipe $.if !config.isJenkins, $.plumber(config.ERROR_HANDLER)
    .pipe $.jade(
              data: require(config.path.jsondata)
              pretty: true
      )
#    .pipe $.htmlhint()
    .pipe $.if config.isRelease, $.minifyHtml()
    .pipe gulp.dest config.outpath.html
    .pipe $.if config.isRelease, $.sitemap(siteUrl: config.mySiteUrl)
    .pipe $.if config.isRelease, gulp.dest config.outpath.html