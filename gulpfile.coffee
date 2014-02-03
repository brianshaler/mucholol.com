gulp = require 'gulp'
gutil = require 'gulp-util'
concat = require 'gulp-concat'
browserify = require 'gulp-browserify'

gulp.task 'build', ->
  gulp.src 'src/app.coffee', {read: false}
  .pipe browserify
    insertGlobals: true
    transform: ['coffeeify']
    extensions: ['.coffee']
  .on 'prebundle', (bundle) ->
    bundle.require './app'
  .on('error', gutil.log)
  .pipe concat 'app.js'
  .pipe gulp.dest 'js'

gulp.task 'watch', -> gulp.watch 'src/**/*.coffee', ['build']

gulp.task 'default', ['build'], ->

