var gulp = require('gulp');

const { series, parallel } = require('gulp');
var del = require('del');
var gulpif = require('gulp-if');
var uglify = require('gulp-uglify');
var cleanCSS = require('gulp-clean-css');
var es = require('event-stream');
var merge = require('merge-stream');
var concat = require('gulp-concat');

var galette = {
    'modules': './node_modules/',
    'public': './galette/webroot/assets/'
};

var main_styles = [
    './galette/webroot/themes/default/galette.css',
    './node_modules/@fortawesome/fontawesome-free/css/fontawesome.min.css',
    './node_modules/jquery-ui-dist/jquery-ui.min.css',
    './galette/webroot/themes/default/jquery-ui/jquery-ui-1.12.1.custom.css',
    './node_modules/selectize/dist/css/selectize.default.css',
];

var main_scripts = [
    './node_modules/jquery/dist/jquery.js',
    './node_modules/jquery-ui-dist/jquery-ui.js',
    './node_modules/jquery.cookie/jquery.cookie.js',
    './node_modules/microplugin/src/microplugin.js',
    './node_modules/sifter/sifter.js',
    './node_modules/selectize/dist/js/selectize.min.js',
];

var main_assets = [
    {
        'src': './node_modules/@fortawesome/fontawesome-free/webfonts/*',
        'dest': '/fonts/'
    }, {
        'src': './node_modules/jquery-ui-dist/images/*',
        'dest': '/images/'
    }, {
        'src': './galette/webroot/themes/default/jquery-ui/images/*',
        'dest': '/images/'
    }
];

const clean = function(cb) {
  del([galette.public]);
  cb();
};

function styles() {
  main = gulp.src(main_styles)
    .pipe(cleanCSS())
    .pipe(concat('galette-main.bundle.min.css'))
    .pipe(gulp.dest(galette.public));

  jqplot = gulp.src('./galette/webroot/js/jquery/jqplot-1.0.8r1250/jquery.jqplot.css')
    .pipe(concat('galette-jqplot.bundle.min.css'))
    .pipe(cleanCSS())
    .pipe(gulp.dest(galette.public));

  return merge(main, jqplot);
};

function scripts() {
  main = gulp.src(main_scripts)
    .pipe(concat('galette-main.bundle.min.js'))
    .pipe(uglify())
    .pipe(gulp.dest(galette.public));

  //use local lib, npm one is missing plugins :/
  jqplot = gulp.src([
        './galette/webroot/js/jquery/jqplot-1.0.8r1250/jquery.jqplot.min.js',
        './galette/webroot/js/jquery/jqplot-1.0.8r1250/plugins/jqplot.barRenderer.min.js',
        './galette/webroot/js/jquery/jqplot-1.0.8r1250/plugins/jqplot.categoryAxisRenderer.min.js',
        './galette/webroot/js/jquery/jqplot-1.0.8r1250/plugins/jqplot.pieRenderer.min.js',
        './galette/webroot/js/jquery/jqplot-1.0.8r1250/plugins/jqplot.pointLabels.min.js',
  ])
    .pipe(concat('galette-jqplot.bundle.min.js'))
    .pipe(gulp.dest(galette.public));

  return merge(main, jqplot);
};

function assets() {
    main = main_assets.map(function (asset) {
        return gulp.src(asset.src)
            .pipe(gulp.dest(galette.public + asset.dest));
        }
    );

    return merge(main);
};

exports.clean = clean;

exports.styles = styles;
exports.scripts = scripts;
exports.assets = assets;

exports.build = series(styles, scripts, assets);
exports.default = exports.build;
