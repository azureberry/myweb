gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
del = require 'del'
bowerfiles  = require 'main-bower-files'

config = require '../config'


gulp.task "lib-clean", (cb) ->
  del([config.outpath.lib], cb)

gulp.task "bower", ['lib-clean'],->
  #bowerパッケージのパス取得
  files = bowerfiles
    paths:
      bowerJson: "bower.json"
      bowerDirectory: "bower_components"

  #bowerパッケージのパスをbower_components/ からのパスに変更
  files = files.map (file)->
    return require("path").relative __dirname + '/../../', file
  console.log "targets: ", files

  #bowerパッケージを種類ごとに結合圧縮して各フォルダに格納
  #各ファイル中にパスが記載されている場合は位置関係が崩れる可能性がある
  cssFilter = $.filter '**/*.css', {restore: true}
  jsFilter =  $.filter '**/*.js', {restore: true}
  imgFilter = $.filter ['**/*.gif', '**/*.png','!**/*@2x.gif', '!**/*@2x.png'], {restore: true}
  fontFilter = $.filter [
                               '**/*.otf'
                               '**/*.eot'
                               '**/*.svg'
                               '**/*.ttf'
                               '**/*.woff'
                               '**/*.woff2'
                             ], {restore: true}
  gulp
    .src files
    .pipe $.if !config.isJenkins, $.plumber(config.ERROR_HANDLER)
    #cssファイルの場合
    .pipe cssFilter
    .pipe $.concat "vender.min.css"
    .pipe $.minifyCss()
    .pipe gulp.dest config.outpath.lib
    .pipe cssFilter.restore
    #jsファイルの場合
   .pipe jsFilter
   .pipe $.concat "vender.min.js"
   .pipe $.uglify
       preserveComments: "some"
   .pipe gulp.dest config.outpath.lib
   .pipe jsFilter.restore
    #画像ファイルの場合
    .pipe imgFilter
    .pipe gulp.dest config.outpath.lib
    .pipe imgFilter.restore
    #フォントファイル
    .pipe fontFilter
    .pipe gulp.dest config.outpath.libfont
    .pipe fontFilter.restore
    #その他ファイル
#    .pipe gulp.dest config.outpath.lib
    return
