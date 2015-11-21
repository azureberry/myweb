# Karma configuration
webpack = require('webpack')
# bowerfiles = require 'main-bower-files'
# path = require "path"
# console.log "targets: ", bowerfiles

module.exports = (config) ->
  config.set
    basePath: ''
    port: 9876
    colors: true
    logLevel: config.LOG_INFO
    autoWatch: true
    singleRun: false

    frameworks: [
      # 'bower'
      # 'jasmine-jquery'
      'jasmine'

      # 'mocha-debug'
      # 'mocha'
      # 'chai'
      # 'karma-e2e-dsl'
    ]

    # bowerPackages: [
    #   'jquery'
    # ]

    files: [
      # bowerFiles
      'WebContent/lib/**/*.js'
      # 'src/coffee/**/*.coffee'
      # 'src/jade/history.jade'

      'WebContent/*.html'
      'WebContent/js/*.js'
      {pattern: 'WebContent/lib/**/*', watched: false, included: false, served: true}
      {pattern: 'WebContent/css/*.css', watched: false, included: false, served: true}
      {pattern: 'WebContent/img/*', watched: false, included: false, served: true}

      'spec/*.coffee'
      # 'spec/e2e/*.coffee'
    ]
    exclude: []

    proxies :
      '/lib/': '/base/WebContent/lib/'
      '/css/': '/base/WebContent/css/'
      '/img/': '/base/WebContent/img/'
      '/js/': '/base/WebContent/js/'


    preprocessors:
      # 'src/jade/**/*.jade': [ 'jade', 'html2js']
      # 'WebContent/**/*.html': ['html2js']
      'WebContent/js/**/*.js': ['coverage']
      # 'src/coffee/**/*.coffee': [ 'webpack' ,'sourcemap', 'coverage' ]
      'spec/**/*.coffee': [ 'webpack' ,'sourcemap']

    reporters: [
      'spec'
      'coverage'
      #'progress'
      # 'html'
    ]
    browsers: [
      'PhantomJS'
      # 'Firefox'
#      'Chrome'
    ]

    coverageReporter:
      type: 'html'
      dir: 'spec/result/coverage/'


    webpack:
      # resolve:
      #   root: [path.join(__dirname, "bower_components")]
      #   moduleDirectories: ["bower_components"]
      #   extensions: ["", ".js", ".coffee", ".webpack.js", ".web.js"]
      module: loaders: [ {
          test: /\.coffee$/
          exclude: /node_modules/
          loader: 'coffee-loader'
          devtool: 'inline-source-map'
          } ]
      # plugins: [
      #   new (webpack.ResolverPlugin)(new (webpack.ResolverPlugin.DirectoryDescriptionFilePlugin)('bower.json', [ 'main' ]))
      # ]

    plugins: [
      ##frameworks
      'karma-jasmine'
      'karma-jasmine-jquery'
      'karma-bower'
      'karma-mocha'
      'karma-mocha-debug'
      'karma-chai'
      'karma-e2e-dsl'

      ##preprocessor
      'karma-webpack'
      'karma-html2js-preprocessor'
      'karma-sourcemap-loader'

      ##launcher
      # 'karma-chrome-launcher'
      'karma-firefox-launcher'
      'karma-phantomjs-launcher'

      ##reporter
      'karma-spec-reporter'
      'karma-coverage'
      'karma-jasmine-html-reporter'
    ]
  return
