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
              isRelease : $.util.env.release?


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



module.exports =
  config: config
