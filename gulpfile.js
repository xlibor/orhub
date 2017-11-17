var elixir = require('laravel-elixir');
require('laravel-elixir-livereload');
require('laravel-elixir-compress');

var production = elixir.config.production;
var basejs = [
    'res/asset/js/vendor/jquery.min.js',
    'res/asset/js/vendor/bootstrap.min.js',
    'res/asset/js/vendor/moment.min.js',
    'res/asset/js/vendor/zh-cn.min.js',
    'res/asset/js/vendor/emojify.min.js',
    'res/asset/js/vendor/jquery.scrollUp.js',
    'res/asset/js/vendor/jquery.pjax.js',
    'res/asset/js/vendor/nprogress.js',
    'res/asset/js/vendor/jquery.autosize.min.js',
    'res/asset/js/vendor/prism.js',
    'res/asset/js/vendor/jquery.textcomplete.js',
    'res/asset/js/vendor/emoji.js',
    'res/asset/js/vendor/marked.min.js',
    'res/asset/js/vendor/ekko-lightbox.js',
    'res/asset/js/vendor/localforage.min.js',
    'res/asset/js/vendor/jquery.inline-attach.min.js',
    'res/asset/js/vendor/snowfall.jquery.min.js',
    'res/asset/js/vendor/upload-image.js',
    'res/asset/js/vendor/bootstrap-switch.js',
    'res/asset/js/vendor/messenger.js',
    'res/asset/js/vendor/anchorific.js',
    'res/asset/js/vendor/analytics.js',
    'res/asset/js/vendor/jquery.jscroll.js',
    'res/asset/js/vendor/jquery.highlight.js',
    'res/asset/js/vendor/jquery.sticky.js',
    'res/asset/js/vendor/sweetalert.js',
    'node_modules/social-share.js/dist/js/social-share.min.js',
];

elixir(function(mix) {
    mix
        .copy([
            'node_modules/bootstrap-sass/assets/fonts/bootstrap'
        ], 'pub/assets/fonts/bootstrap')

        .copy([
            'node_modules/font-awesome/fonts'
        ], 'pub/assets/fonts/font-awesome')

        // https://github.com/overtrue/share.js
        .copy([
            'node_modules/social-share.js/dist/fonts'
        ], 'pub/assets/fonts/iconfont')

        .copy([
            'node_modules/social-share.js/dist/fonts'
        ], 'public/build/assets/fonts/iconfont')

        .copy([
            'res/asset/fonts/googlefont'
        ], 'public/build/assets/fonts/googlefont')

        .sass([
            'base.scss',
            'main.scss',
        ], 'pub/assets/css/styles.css')

        .scripts(basejs.concat([
            'res/asset/js/main.js',
        ]), 'pub/assets/js/scripts.js', './')

        // API Web View
        .sass([
            'api/api.scss'
        ], 'pub/assets/css/api.css')
        // API Web View
        .scripts([
            'api/emojify.js',
            'api/api.js'
        ], 'pub/assets/js/api.js')

        // editor
        .scripts([
            'vendor/inline-attachment.js',
            'vendor/codemirror-4.inline-attachment.js',
            'vendor/simplemde.min.js',
        ], 'pub/assets/js/editor.js')

        // API Web View
        .sass([
            'vendor/simplemde.min.scss'
        ], 'pub/assets/css/editor.css')

        .version([

            'assets/css/styles.css',
            'assets/js/scripts.js',

            // API Web View
            'assets/css/api.css',
            'assets/js/api.js',

            // API Web View
            'assets/css/editor.css',
            'assets/js/editor.js',

        ]);

    if (production) {
        mix.compress();
    }
});
