$             = require('gulp-load-plugins')()

$src=  './src'
$WebContent=  './WebContent'
configDirName = '/../conf'
configFileName = 'config'

module.exports =
    $src:  './src'
    $WebContent:  './WebContent'
    mySiteUrl : 'http://sora9.web.fc2.com/'


    # config =
    path:
        js: $src + '/coffee/**/*.coffee'
        jslintConfig: __dirname + configDirName + '/coffeelint.json'
        webpack:  __dirname + configDirName + '/webpack.config.coffee'
        sass: $src + '/scss/**/*.scss'
        sassroot: $src + '/scss/style.scss'
        sasslintConfig: __dirname + configDirName + '/sasslint.yml'
        # sassSourceMap: '../../'+$src + '/scss'
        jade: $src + '/jade/**/*.jade'
        jadetask: $src + '/jade/**/!(_)*.jade'
        json: $src + '/json'
        jsondata: '../../' + $src + '/json/'+configFileName+'.json'
        yml: $src + '/json/**/*.yml'
        img: $src + '/img/**/*'
        link : $src + '/link/**/*'
        deploy: $WebContent + '/**/*'
    outpath:
        js: $WebContent + '/js'
        css: $WebContent + '/css'
        html: $WebContent
        img: $WebContent  + '/img'
        link: $WebContent + '/link'
        lib: $WebContent + '/lib'
        libfont: $WebContent + '/lib/fonts'
        sourcemap: __dirname + '/../sourcemap'
        lint:  __dirname + '/../result/lint'
    test:
        # karma:  __dirname + configDirName + '/karma.conf.coffee'
        protractor:  __dirname + configDirName + '/protractor.conf.coffee'
        spec: './spec/e2e/**/*Spec.coffee'
        host: 'localhost'
        port: 8888

    ERROR_HANDLER :
      errorHandler: $.notify.onError('<%= error.message %>')

    AUTOPREFIXER_BROWSERS : [
          'ie >= 10',
          'ff >= 30',
          'chrome >= 34',
          'safari >= 7',
          'opera >= 23',
    ]

    isJenkins : $.util.env.jenkins?
    isRelease : $.util.env.release?
