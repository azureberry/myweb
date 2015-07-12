gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
bowerfiles  = require 'main-bower-files'
runSequence = require 'run-sequence'
wiredep = require('wiredep').stream
del = require 'del'
browserSync = require 'browser-sync'

karma = require('karma').server


#path
$src = './src'
$WebContent = './WebContent'
mySiteUrl = 'http://sora9.web.fc2.com/'
configFileName = 'config'
config =
              path:
                 js: $src + '/coffee/**/*.coffee'
                 jslintConfig: __dirname + '/coffeelint.json'
                 sass: $src + '/scss/**/*.scss'
                 sassroot: $src + '/scss/style.scss'
                 sasslintConfig: __dirname + '/sasslint.yml'
                 # sassSourceMap: '../../'+$src + '/scss'
                 jade: $src + '/jade/**/*.jade'
                 jadetask: $src + '/jade/**/!(_)*.jade'
                 json: $src + '/json'
                 jsondata: $src + '/json/'+configFileName+'.json'
                 yml: $src + '/json/**/*.yml'
                 img: $src + '/img/**/*'
                 link : $src + '/link/**/*'
                 webpack:  __dirname + '/webpack.config.coffee'
              outpath:
                js: $WebContent + '/js'
                css: $WebContent + '/css'
                html: $WebContent
                img: $WebContent  + '/img'
                link: $WebContent + '/link'
                lib: $WebContent + '/lib'
                libfont: $WebContent + '/lib/fonts'
                sourcemap: __dirname + '/sourcemap'
                # sourcemap: 'sourcemap'
              test:
                karma:  __dirname + '/karma.conf.coffee'
                protractor:  __dirname + '/protractor.conf.coffee'
                spec: './spec/e2e/e2eSpec.coffee'
                host: 'localhost'
                port: 8888


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
isJenkins = $.util.env.jenkins?

gulp.task 'js-lint', ->
  gulp
    .src config.path.js
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe $.coffeelint(config.path.jslintConfig)
    .pipe $.coffeelint.reporter()

gulp.task 'js', ->
  gulp
    .src config.path.js
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe $.webpack require(config.path.webpack)
    .pipe $.if isRelease, $.uglify()
    .pipe gulp.dest config.outpath.js

gulp.task 'sass-lint', ->
  gulp
    .src config.path.sass
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
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

# gulp.task 'json', ->
#   gulp
#     .src config.path.jsondata
#     .pipe $.jsonlint()
#     .pipe $.jsonlint.reporter()

gulp.task 'yml-lint', ->
  gulp
    .src config.path.yml
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe $.yamlValidate({safe : true})

gulp.task 'yml', ->
  gulp
    .src config.path.yml
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe $.concat(configFileName+'.yml')
    .pipe $.convert(
              from: 'yml',
              to: 'json')
    .pipe gulp.dest config.path.json

gulp.task 'jade', ->
  gulp
    .src config.path.jadetask
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe $.jade(
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
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
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

gulp.task "wiredep", ->
  gulp
    .src config.path.sass
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
  $.watch config.path.sass, ->gulp.start ['sass','brower-reload']
  $.watch [config.path.yml], ->gulp.start ['yml']
#  $.watch [config.path.json], ->gulp.start ['json','jade']
  $.watch [config.path.jade, config.path.jsondata], ->gulp.start ['jade','brower-reload']
  $.watch config.path.img, ->gulp.start ['img','brower-reload']
  $.watch config.path.link, ->gulp.start ['link','brower-reload']


gulp.task 'default', ['browser', 'watch']
gulp.task 'build', -> runSequence(
  'bower',
  ['js',
  'sass',
#  'json',
  'yml'],
  'jade',
  ['img',
  'link'],
)

###
  test
###
gulp.task 'karma', ->
  karma.start {configFile: config.test.karma}

gulp.task 'webserver-start', ->
  gulp.src('./WebContent')
  .pipe $.webserver
    host: config.test.host
    port: config.test.port

gulp.task 'protractor', ->
  gulp.src([config.test.spec])
    .pipe $.protractor.protractor(
      configFile: config.test.protractor
      args: ['--baseUrl', 'http://'+config.test.host+':'+config.test.port]
      )
    .on 'end', -> process.exit()
    .on 'error', (e) -> throw e


gulp.task 'test', (callback) ->
  runSequence(
    'webserver-start'
    'protractor'
    callback
    )