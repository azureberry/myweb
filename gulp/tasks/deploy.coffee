gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
ftp = require 'vinyl-ftp'

config = require '../config'


gulp.task 'deploy', ->
  conn = ftp.create(
    host: $.util.env.ftphost
    user: $.util.env.ftpuser
    password: $.util.env.ftppass
    # parallel: 10
    log: $.util.log
    )

  gulp
  .src(config.path.deploy,
      base: config.$WebContent
      buffer: false
      )
  .pipe conn.differentSize('/')
  .pipe conn.dest('/')