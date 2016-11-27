webpack = require 'webpack'
webpackConfig = require './webpack.config'

module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON("package.json")
    aws_s3:
      options:
        accessKeyId: '<%= process.env.AWS_ACCESS_KEY %>'
        secretAccessKey: '<%= process.env.AWS_SECRET_KEY %>'
        region: 'us-east-1'
        uploadConcurrency: 5
        downloadConcurrency: 5
      production:
        options:
          bucket: 'peppermile.com'
        files: [
          {expand: true, cwd: 'build/', src: ['**'], dest: '/', stream: true},
        ]
    exec:
      build: "node -r coffee-script/register index.coffee"
    webpack:
      options: webpackConfig
      production: 
        plugins: webpackConfig.plugins.concat(
          new webpack.optimize.UglifyJsPlugin(),
          new webpack.DefinePlugin({'process.env': {NODE_ENV: JSON.stringify("production")}})
        )
  )

  grunt.loadNpmTasks 'grunt-aws-s3'
  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-webpack'

  grunt.registerTask 'default', ['exec:build', 'webpack:production']
  grunt.registerTask 'deploy', ['exec:build', 'webpack:production', 'aws_s3:production']
