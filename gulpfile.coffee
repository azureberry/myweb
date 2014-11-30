gulp         = require 'gulp'
$             = require('gulp-load-plugins')()
bowerfiles  = require 'main-bower-files'
#runSeq = require 'run-sequence'

#path
$src = './src'
$WebContent = './WebContent'
mySiteUrl = 'http://sora9.web.fc2.com/'
config =
              path:
                 js: $src + '/coffee/**/*.coffee'
                 scss: $src + '/scss/**/*.scss'
                 scssSourceMap: '../../'+$src + '/scss'
                 jade: $src + '/jade/**/*.jade'
                 jadetask: $src + '/jade/**/!(_)*.jade'
                 jsondata: $src + '/json/config.json'
                 img: $src + '/img/**/*'
                 link: $src + '/link/**/*'
              outpath:
                js: $WebContent + '/js'
                css: $WebContent + '/css'
                html: $WebContent
                img: $WebContent + '/img'
                link: $WebContent + '/link'
                lib: $WebContent + '/lib'

isRelease = $.util.env.release?

gulp.task 'js', ->
  gulp
    .src config.path.js
    .pipe $.coffeelint()
    .pipe $.coffee()
#    .pipe $.jshint()
#    .pipe $.jshint.reporter 'jshint-stylish'
    .pipe $.if isRelease, $.uglify()
    .pipe gulp.dest config.outpath.js


gulp.task 'scss', ->
  gulp
    .src config.path.scss
    .pipe $.plumber()
    .pipe $.scssLint()
    .pipe $.rubySass(compass : true)
#    .pipe $.pleeease()
#    .pipe $.minifyCss()
    .pipe gulp.dest config.outpath.css

gulp.task 'json', ->
  gulp
    .src config.path.jsondata
    .pipe $.jsonlint()
    .pipe $.jsonlint.reporter()

gulp.task 'jade', ->
  gulp
    .src config.path.jadetask
    .pipe $.plumber()
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

gulp.task 'bower', ->
  gulp.src bowerfiles()
#    .pipe $.if '*.js', $.concat('vender.js')
    .pipe $.if '*.js', $.uglify(preserveComments: 'some')
    .pipe $.if '*.css', $.concat('vender.css')
    .pipe gulp.dest config.outpath.lib


gulp.task 'watch', ->
  gulp.watch config.path.js, ['js']
  gulp.watch config.path.scss, ['scss']
  gulp.watch [config.path.jsondata], ['json','jade']
  gulp.watch [config.path.jade], ['jade']
  gulp.watch config.path.img, ['img']
  gulp.watch config.path.link, ['link']


gulp.task 'default', ['watch']
gulp.task 'build', [
  'bower',
  'js',
  'scss',
  'json',
  'jade',
  'img',
  'link',
]