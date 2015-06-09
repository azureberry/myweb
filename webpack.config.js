var path = require("path");
var webpack = require("webpack");

module.exports = {
    resolve: {
        root: [path.join(__dirname, "bower_components")]
    },
   output: {
      filename: "./vender.min.js"
    },
    plugins: [
        new webpack.ResolverPlugin(
            new webpack.ResolverPlugin.DirectoryDescriptionFilePlugin("bower.json", ["main"])
        )
    ]
}