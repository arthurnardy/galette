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
    path: path.join(__dirname, 'galette', 'webroot', 'js', 'libs')
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
    rules: [
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader'],
      },
      {
        test: /\.(png|jpe?g|gif)$/i,
        use: [
          {
            loader: 'file-loader',
            options:{
              name:'[name].[ext]',
              outputPath:'assets/images/'
            }
          },
        ],
      },
    ],
  }
}
