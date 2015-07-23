gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
bowerfiles  = require 'main-bower-files'
runSequence = require 'run-sequence'
wiredep = require('wiredep').stream
del = require 'del'
browserSync = require 'browser-sync'
ftp = require 'vinyl-ftp'
webpack = require 'webpack-stream'

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
                 deploy: $WebContent + '/**/*'
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
                lint:  __dirname + '/result/lint'
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
  tempfunc = console.log
  if isJenkins
    fs = require('fs')
    log_file = fs.createWriteStream(config.outpath.lint + '/coffeelint.xml', {flags : 'w'})
    console.log = (d) ->
      log_file.write d.replace(/[\u001b\u009b][[()#;?]*(?:[0-9]{1,4}(?:;[0-9]{0,4})*)?[0-9A-ORZcf-nqry=><]/g, '') + '\n'

  gulp
    .src config.path.js
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe $.coffeelint(optFile: config.path.jslintConfig)
    .pipe $.if !isJenkins, $.coffeelint.reporter(), $.coffeelint.reporter('checkstyle')
    .on 'end', -> $.if isJenkins, console.log = tempfunc

gulp.task 'js', ->
  gulp
    .src config.path.js
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe webpack require(config.path.webpack)
    .pipe $.if isRelease, $.uglify()
    .pipe gulp.dest config.outpath.js

gulp.task 'sass-lint', ->
  sasslintConfig = {
      config : config.path.sasslintConfig
      customReport: $.scssLintStylish2().issues
    }
  if isJenkins
    sasslintConfig.reporterOutputFormat = 'Checkstyle'
    sasslintConfig.filePipeOutput = 'scssReport.xml'

  gulp
    .src config.path.sass
    .pipe $.if !isJenkins, $.plumber(ERROR_HANDLER)
    .pipe $.scssLint(sasslintConfig)
    .pipe $.scssLintStylish2().printSummary
    .pipe $.if isJenkins, gulp.dest config.outpath.lint


gulp.task 'sass', ->
    $.rubySass(config.path.sassroot,
      style: 'expanded'
      sourcemap: true
      defaultEncoding: 'utf-8'
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
  cssFilter = $.filter '**/*.css'
  jsFilter =  $.filter '**/*.js'
  imgFilter = $.filter ['**/*.gif', '**/*.png','!**/*@2x.gif', '!**/*@2x.png']
  fontFilter = $.filter [
                               '**/*.otf'
                               '**/*.eot'
                               '**/*.svg'
                               '**/*.ttf'
                               '**/*.woff'
                               '**/*.woff2'
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
      base: $WebContent
      buffer: false
      )
  .pipe conn.differentSize('/')
  .pipe conn.dest('/')

gulp.task 'json2yml', ->
  gulp.src config.path.jsondata
   .pipe $.convert(
      from: 'json',
      to: 'yml')
   .pipe gulp.dest $src + '/json'

gulp.task 'default', ['browser', 'watch']

gulp.task 'watch', ->
  $.watch config.path.js, ->gulp.start ['js','brower-reload']
  $.watch config.path.sass, ->gulp.start ['sass','brower-reload']
  $.watch [config.path.yml], ->gulp.start ['yml']
  $.watch [config.path.jade, config.path.jsondata], ->gulp.start ['jade','brower-reload']
  $.watch config.path.img, ->gulp.start ['img','brower-reload']
  $.watch config.path.link, ->gulp.start ['link','brower-reload']


gulp.task 'build', -> runSequence(
  'bower',
  ['js',
  'sass',
  'yml',
  'img',
  'link'],
  'jade'
)

gulp.task 'lint', ['sass-lint', 'js-lint']

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