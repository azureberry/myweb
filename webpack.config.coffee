path = require('path')
webpack = require('webpack')

module.exports =
  resolve:
    root: [ path.join(__dirname, 'bower_components') ]
    # requireやimport時の拡張子を省略
    extensions: ['', '.js', '.jsx', '.coffee', '.css', '.styl']

  # entry:
  #   app: ['./src/js/app.coffee']

  output:
    filename: 'app.js'
    sourceMapFilename: __dirname + '/../../sourcemap/[file].map'

  # devtool: 'source-map'

  module: loaders: [ {
          test: /\.coffee$/
          exclude: /node_modules/
          loader: 'coffee-loader'
          } ]

  plugins:[
    new (webpack.ResolverPlugin)(
        new (webpack.ResolverPlugin.DirectoryDescriptionFilePlugin)('bower.json', [ 'main' ]))
  ]
