gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
bowerfiles  = require 'main-bower-files'
runSequence = require 'run-sequence'
#manifest     = require('asset-builder')('./manifest.json')
wiredep = require('wiredep').stream
#webpack = require('webpack')
del = require 'del'
browserSync = require 'browser-sync'

#path
$src = './src'
$WebContent = './WebContent'
mySiteUrl = 'http://sora9.web.fc2.com/'
configFileName = 'config'
config =
              path:
                 js: $src + '/coffee/**/*.coffee'
                 scss: $src + '/scss/**/*.scss'
                 scssSourceMap: '../../'+$src + '/scss'
                 jade: $src + '/jade/**/*.jade'
                 jadetask: $src + '/jade/**/!(_)*.jade'
#                 jadebase: $src + '/jade/'
                 json: $src + '/json'
                 jsondata: $src + '/json/'+configFileName+'.json'
                 yml: $src + '/json/**/*.yml'
                 img: $src + '/img/**/*'
                 link: $src + '/link/**/*'
              outpath:
                js: $WebContent + '/js'
                css: $WebContent + '/css'
                html: $WebContent
                img: $WebContent + '/img'
                link: $WebContent + '/link'
                lib: $WebContent + '/lib'
                libfont: $WebContent + '/lib/fonts'

AUTOPREFIXER_BROWSERS = [
      'ie >= 10',
      'ff >= 30',
      'chrome >= 34',
      'safari >= 7',
      'opera >= 23',
];

ERROR_HANDLER = {
  errorHandler: $.notify.onError('<%= error.message %>')
}

isRelease = $.util.env.release?

gulp.task 'js', ->
  gulp
    .src config.path.js
    .pipe $.plumber(ERROR_HANDLER)
    .pipe $.coffeelint()
    .pipe $.coffeelint.reporter()
    .pipe $.coffee()
#    .pipe $.jshint()
#    .pipe $.jshint.reporter 'jshint-stylish'
    .pipe $.if isRelease, $.uglify()
    .pipe gulp.dest config.outpath.js

gulp.task 'scss', ->
  gulp
    .src config.path.scss
    .pipe $.plumber(ERROR_HANDLER)
#    .pipe wiredep()
    .pipe $.scssLint()
    .pipe $.rubySass(compass : true)
    .pipe $.pleeease(
              autoprefixer: AUTOPREFIXER_BROWSERS,
              minifier: false
      )
    .pipe $.if isRelease, $.minifyCss()
    .pipe gulp.dest config.outpath.css

gulp.task 'json', ->
  gulp
    .src config.path.jsondata
    .pipe $.jsonlint()
    .pipe $.jsonlint.reporter()

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
#              basedir: config.path.jadebase
              data: require(config.path.jsondata)
              pretty: true
      )
#    .pipe $.htmlhint()
    .pipe $.if isRelease, $.minifyHtml()
    .pipe gulp.dest config.outpath.html
    .pipe $.if isRelease, $.sitemap(siteUrl: mySiteUrl)
    .pipe $.if isRelease, gulp.dest config.outpath.html

gulp.task 'img', ->
  gulp
    .src config.path.img
#    .pipe $.plumber()
    .pipe gulp.dest config.outpath.img

gulp.task 'link', ->
  gulp
    .src config.path.link
#    .pipe $.plumber()
    .pipe gulp.dest config.outpath.link

gulp.task 'browser', ->
  browserSync.init
    server:
      baseDir: $WebContent

gulp.task 'brower-reload', ->
  browserSync.reload()

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
    return require("path").relative __dirname, file
  console.log "targets: ", files

  #bowerパッケージを種類ごとに結合圧縮して各フォルダに格納
  #各ファイル中にパスが記載されている場合は位置関係が崩れる可能性がある
  cssFilter = $.filter "**/*.css"
  jsFilter =  $.filter "**/*.js"
  imgFilter = $.filter ["**/*.gif", "**/*.png"]
  fontFilter = $.filter [
                               "**/*.otf"
                               "**/*.eot"
                               "**/*.svg"
                               "**/*.ttf"
                               "**/*.woff"
                               "**/*.woff2"
                             ]
  gulp
    .src files
    .pipe $.plumber(ERROR_HANDLER)
    #cssファイルの場合
    .pipe cssFilter
    .pipe $.concat "vender.min.css"
    .pipe $.minifyCss()
    .pipe gulp.dest config.outpath.lib
    .pipe cssFilter.restore()
    #jsファイルの場合
   .pipe jsFilter
   .pipe $.concat "vender.min.js"
   .pipe $.uglify
       preserveComments: "some"
   .pipe gulp.dest config.outpath.lib
   .pipe jsFilter.restore()
    #画像ファイルの場合
    .pipe imgFilter
    .pipe gulp.dest config.outpath.lib
    .pipe imgFilter.restore()
    #フォントファイル
    .pipe fontFilter
    .pipe gulp.dest config.outpath.libfont
    .pipe fontFilter.restore()
    #その他ファイル
#    .pipe gulp.dest config.outpath.lib
    return

###
gulp.task "webpack", ->
  webpack require('./webpack.config.js')
###

gulp.task "wiredep", ->
  gulp
    .src config.path.scss
    .pipe wiredep()
    .pipe gulp.dest $src + '/scss/'

gulp.task 'json2yml', ->
  gulp.src config.path.jsondata
   .pipe $.convert(
      from: 'json',
      to: 'yml')
   .pipe gulp.dest $src + '/json'

gulp.task 'watch', ->
  $.watch config.path.js, ->gulp.start ['js','brower-reload']
  $.watch config.path.scss, ->gulp.start ['scss','brower-reload']
  $.watch [config.path.yml], ->gulp.start ['yml']
#  $.watch [config.path.json], ->gulp.start ['json','jade']
  $.watch [config.path.jade, config.path.jsondata], ->gulp.start ['jade','brower-reload']
  $.watch config.path.img, ->gulp.start ['img','brower-reload']
  $.watch config.path.link, ->gulp.start ['link','brower-reload']


gulp.task 'default', ['browser', 'watch']
gulp.task 'build', -> runSequence(
  'bower',
  ['js',
  'scss',
#  'json',
  'yml'],
  'jade',
  ['img',
  'link'],
)