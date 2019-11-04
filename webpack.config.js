const path = require('path')
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: {
      main: './galette-main.js',
  },
  mode: 'none',
  output: {
    filename: "galette-[name].bundle.js",
    path: path.join(__dirname, 'galette', 'webroot', 'js', 'libs'),
    publicPath: "js/libs/"
  },
  plugins: [
    new webpack.ProvidePlugin({
      "$":"jquery",
      "jQuery":"jquery",
      "window.jQuery":"jquery",
      "window.$": "jquery"
    }),
  ],
  resolve: {
    alias: {
      modules: path.join(__dirname, "node_modules"),
      'jquery': path.join(__dirname, '/node_modules/jquery/dist/jquery.min.js'),
      'selectize-css': path.join(__dirname, '/node_modules/selectize/dist/css/selectize.default.css')
    }
  },
  module: {
    rules: [{
      test: /\.css$/,
      loader: 'style-loader!css-loader?sourceMap'
    }, {
        test: /\.(woff2?|ttf|eot)(\?v=\d+\.\d+\.\d+)?$/,
        use: [
          {
            loader: 'file-loader',
            options:{
              name:'[name].[ext]',
              outputPath:'fonts/'
            }
          },
        ],
    }, {
        test: /\.(png|jpe?g|gif|svg)(\?v=\d+\.\d+\.\d+)?$/i,
        use: [
          {
            loader: 'file-loader',
            options:{
              name:'[name].[ext]',
              outputPath:'images/'
            }
          },
        ],
      }
    ]
  }
}
