const path = require('path')
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
  entry: './galette-main.js',
  mode: 'none',
  output: {
    filename: "galette-main.bundle.js",
    path: path.join(__dirname, 'galette', 'webroot', 'js', 'libs')
  },
  plugins: [
    new webpack.ProvidePlugin({
      "$":"jquery",
      "jQuery":"jquery",
      "window.jQuery":"jquery",
      "window.$": "jquery"
    }),
    /*new CopyWebpackPlugin([
      {
        from: path.resolve(__dirname, 'node_modules/@fullcalendar/core/main.min.css'),
        to: path.resolve(__dirname, 'webroot/js/libs/fullcalendar.min.css')
      }, {
        from: path.resolve(__dirname, 'node_modules/@fullcalendar/daygrid/main.min.css'),
        to: path.resolve(__dirname, 'webroot/js/libs/fullcalendar-daygrid.min.css')
      }
    ])*/
  ],
  //devtool: 'sourcemap',
  resolve: {
    //extensions: [ '.js' ],
    alias: {
      // bind version of jquery-ui
      //"jquery-ui": "jquery-ui/jquery-ui.js",
      // bind to modules;
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
              //the images will be emited to dist/assets/images/ folder
            }
          },
        ],
      },
    ],
  }
}
