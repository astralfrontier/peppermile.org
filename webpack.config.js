const webpack = require('webpack');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const CompressionPlugin = require("compression-webpack-plugin");

const babelLoader = {
  test: /^((?!.config.).).js$/,
  loader: 'babel',
  query: {
    presets: ['latest']
  }
};

const coffeeLoader = {
  test: /\.coffee$/,
  loader: 'coffee'
};

const cssLoader = {
  test: /\.css$/,
  loader: ExtractTextPlugin.extract("style-loader", "css-loader")
};

const lessLoader = {
  test: /\.less$/,
  loader: ExtractTextPlugin.extract("style-loader", "css-loader!less-loader")
};

/* Font loaders */
const woffLoader = {test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/, loader: 'url?limit=10000&mimetype=application/font-woff'};
const ttfLoader = {test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/, loader: 'url?limit=10000&mimetype=application/octet-stream'};
const eotLoader = {test: /\.eot(\?v=\d+\.\d+\.\d+)?$/, loader: 'file'};
const svgLoader = {test: /\.svg(\?v=\d+\.\d+\.\d+)?$/, loader: 'url?limit=10000&mimetype=image/svg+xml'};

module.exports = {
  entry: [
    'babel-polyfill',
    'bootstrap-webpack!./lib/bootstrap.config.js',
    'font-awesome-webpack!./lib/font-awesome.config.js',
    './lib/peppermile.js'
  ],
  module: {
    loaders: [babelLoader, coffeeLoader, cssLoader, lessLoader, woffLoader, ttfLoader, eotLoader, svgLoader]
  },
  output: {
    path: './build/assets',
    publicPath: '/assets/',
    filename: 'peppermile.js'
  },
  plugins: [
    new ExtractTextPlugin('peppermile.css', {allChunks: true}),
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    }),
    new CompressionPlugin({
      asset: "[path].gz[query]",
      algorithm: "gzip",
      test: /\.css$|\.js$/,
      threshold: 10240,
      minRatio: 0.8
    })
  ]
};
