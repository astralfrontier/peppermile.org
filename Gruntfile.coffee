module.exports = (grunt) ->
  grunt.initConfig(
    aws: grunt.file.readJSON('aws-keys.json')
    pkg: grunt.file.readJSON("package.json")
    aws_s3:
      options:
        accessKeyId: '<%= aws.AWSAccessKeyId %>'
        secretAccessKey: '<%= aws.AWSSecretKey %>'
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
      build: "node --harmony node_modules/coffee-script/bin/coffee index.coffee"
  )

  grunt.loadNpmTasks 'grunt-exec'
  grunt.loadNpmTasks 'grunt-aws-s3'

  grunt.registerTask 'default', ['exec:build']
  grunt.registerTask 'deploy', ['exec:build', 'aws_s3:production']
