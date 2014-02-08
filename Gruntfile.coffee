module.exports = (grunt) ->
  pkg = grunt.file.readJSON 'package.json'
  grunt.initConfig
    paths:
      css: 'WebContent/css/'
      cssdist: 'WebContent/dist/css/'
      img: 'WebContent/img/'
      imgdist: 'WebContent/dist/img/'

    autoprefixer:
      options:
        browsers: ['last 2 version']

    files:
      expand: true
      flatten: true
      src: '<%= paths.css %>*.css'
      dest: '<%= paths.cssdist %>pre/'

    cssmin:
      compress:
        files:
          '<%= paths.cssdist %>style.min.css': ['<%= paths.cssdist %>pre/*.css']

    imagemin:
      dynamic:
        files: [
          expand: true
          cwd: '<%= paths.img %>'
          src: '**/*.{jpg,gif}'
          dest: '<%= paths.imgdist %>'
        ]

    pngmin:
      compile:
        options:
          ext: '.png'
      files: [
        expand: true
        cwd: '<%= paths.img %>'
        src: '**/*.png'
        dest: '<%= paths.imgdist %>'
      ]

    watch:
      css:
        files: ['<%= paths.css %>*.css']
      tasks: ['autoprefixer', 'cssmin']

    img:
      files: ['<%= paths.img %>**/*.{png,jpg,gif}']
      tasks: ['imagemin', 'pngmin']


  # loadNpmTasks
  # package.jsonから読み込んでるもの
  # grunt-contrib-stylus, grunt-contrib-cssmin, grunt-contrib-watch
  for taskName of pkg.devDependencies when taskName.substring(0, 6) is 'grunt-'
    grunt.loadNpmTasks taskName

  grunt.registerTask 'default', ['autoprefixer', 'cssmin', 'imagemin', 'pngmin']