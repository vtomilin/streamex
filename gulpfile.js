var pathDelimiter = require('path').delimiter,
    exec = require('child_process').exec,
    del = require('del'),
    gulp = require('gulp'),
    coffee = require('gulp-coffee'),
    changed = require('gulp-changed'),
    src = ['src/*.litcoffee'],
    dest = 'lib';

gulp.task('compile', function() {
    return gulp.src(src)
        .pipe(changed(dest, {extension: '.js'}))
        .pipe(coffee())
        .pipe(gulp.dest(dest));
});

gulp.task('docco', function(cb) {
    exec('docco -o doc src/linestream.litcoffee src/bufferstream.litcoffee',
         {
            env: {
                PATH: process.env.PATH + pathDelimiter + 'node_modules/.bin'
            }
         },
         function(err, stdout, stderr) {
            if(err) {
                return cb(err);
            }

            cb();
         });
});

gulp.task('clean', function(cb) {
    del(['lib', 'doc'], cb);
});

gulp.task('default', ['compile']);