module.exports = (grunt) ->
  grunt.initConfig(
    pkg: grunt.file.readJSON("package.json")
    exec:
      build: "node --harmony node_modules/coffee-script/bin/coffee index.coffee"
      rsync: "rsync -av --delete build/ ubuntu@deploy.peppermile.org:/var/www/html"
  )

  grunt.loadNpmTasks 'grunt-exec'

  grunt.registerTask 'default', ['exec:build']
  grunt.registerTask 'deploy', ['exec:build', 'exec:rsync']
