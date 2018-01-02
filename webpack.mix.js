let mix = require('laravel-mix');

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
    'res/asset/js/vendor/jquery.navScrollSpy.js'
];

mix
    .setPublicPath('pub')
    .copy([
        'node_modules/bootstrap-sass/assets/fonts/bootstrap'
        ], 'pub/assets/fonts/bootstrap')

    .copy([
        'node_modules/font-awesome/fonts'
    ], 'pub/assets/fonts/font-awesome')

    .copy([
        'node_modules/social-share.js/dist/fonts'
    ], 'pub/assets/fonts/iconfont')

    .copy([
        'res/asset/fonts/googlefont'
    ], 'pub/assets/fonts/googlefont')

    .sass('res/asset/sass/base.scss', 'pub/css/base.css')
    .sass('res/asset/sass/main.scss', 'pub/css/main.css')

    .sass('res/asset/sass/vendor/simplemde.min.scss', 'pub/css/editor.css')
    .sass('res/asset/sass/api/api.scss', 'pub/css/api.css')

    .styles([
        'pub/css/base.css', 'pub/css/main.css'
    ], 'pub/css/styles.css')

    .scripts(basejs.concat([
        'res/asset/js/main.js',
    ]), 'pub/js/scripts.js')

    .scripts([
        'res/asset/js/api/emojify.js',
        'res/asset/js/api/api.js'
    ], 'pub/js/api.js')

    // editor
    .scripts([
        'res/asset/js/vendor/inline-attachment.js',
        'res/asset/js/vendor/codemirror-4.inline-attachment.js',
        'res/asset/js/vendor/simplemde.min.js',
    ], 'pub/js/editor.js')
    .version([

        'pub/css/styles.css',
        'pub/js/scripts.js',

        'pub/css/api.css',
        'pub/js/api.js',

        'pub/css/editor.css',
        'pub/js/editor.js',
    ])

    .options({
      processCssUrls: false
    })

    .sourceMaps();
