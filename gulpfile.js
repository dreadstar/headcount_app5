// Include gulp
var gulp = require('gulp'); 

// Include Our Plugins
var jshint = require('gulp-jshint');
var sass = require('gulp-sass');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var rename = require('gulp-rename');
var coffeelint = require('gulp-coffeelint');
var coffee = require('gulp-coffee');
var gutil = require('gulp-util');
var sourcemaps = require('gulp-sourcemaps');


// Lint Task
gulp.task('lint', function() {
    return gulp.src('js/*.js')
        .pipe(jshint())
        .pipe(jshint.reporter('default'));
        
});
gulp.task('coffeelint', function () {
    return gulp.src('./src/*.coffee')
        .pipe(coffeelint())
        .pipe(coffeelint.reporter())
        .pipe(coffeelint.reporter('fail'));
});

// Compile Our Sass
gulp.task('sass', function() {
    return gulp.src('scss/*.scss')
        .pipe(sass())
        .pipe(gulp.dest('css'));
});

// Concatenate & Minify JS
gulp.task('scripts', function() {
    return gulp.src('js/*.js')
        .pipe(concat('all.js'))
        .pipe(gulp.dest('dist'))
        .pipe(rename('all.min.js'))
        .pipe(uglify())
        .pipe(gulp.dest('dist'));
});
gulp.task('coffee', function() {
       gulp.src('./src/*.coffee')
        .pipe(sourcemaps.init())
        .pipe(coffee({bare: true}).on('error', gutil.log))
        .pipe(gulp.dest('./public/'))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest('./dest/js'));
});

// Watch Files For Changes
gulp.task('watch', function() {
    gulp.watch('js/*.js', ['lint', 'scripts']);
    gulp.watch('scss/*.scss', ['sass']);
});

// Default Task
gulp.task('default', ['lint', 'sass', 'scripts', 'watch']);