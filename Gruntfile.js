module.exports = function(grunt) {

  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    coffee: {
      compile: {
        files: {
          'dist/photoflip.min.js': 'photoflip.coffee'
        }
      }
    },
    uglify: {
      dist: {
        files: {
          'dist/photoflip.min.js': 'dist/photoflip.min.js'
        }
      }
    },
    cssmin: {
      dist: {
        files: {
          'dist/photoflip.min.css': ['photoflip.css']
        }
      }
    },
    watch: {
      scripts: {
        files: ['*.coffee', '*.css'],
        tasks: ['default']
      }
    },
    connect: {
      server: {
        options: {
          port: 9001,
          base: 'demo',
          keepalive: true
        }
      }
    }
  });

  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.loadNpmTasks('grunt-contrib-connect');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.registerTask('default', ['coffee', 'uglify', 'cssmin']);

};
