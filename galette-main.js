global.$ = require("jquery")
global.jQuery = require("jquery")
require('jquery-migrate');
require('webpack-jquery-ui');
require('webpack-jquery-ui/css');
require('bgfade');
require('jquery.cookie');

var _initTooltips = function(selector) {
    if (typeof(selector) == 'undefined') {
        selector = '';
    } else {
        selector = selector + ' ';
    }

    //for tootltips
    //first, we hide tooltips in the page
    $(selector + '.tip').hide();
    $(selector + ' label.tooltip, ' + selector + ' span.bline.tooltip').each(function() {
        var __i = $('<i class="fas fa-exclamation-circle"></i>')
        $(this).append(__i);
    });
    //and then, we show them on rollover
    $(document).tooltip({
        items: selector + ".tooltip, a[title]",
        content: function(event, ui) {
            var _this = $(this);

            var _next = _this.nextAll('.tip');
            if (_next.length == 0) {
                _next = _this.find('.sr-only');
            }

            if (_next.length == 0) {
                return _this.attr('title');
            } else {
                return _next.html();
            }
        }
    });
}

$(function() {
    console.log('Galette core loaded!');
    _initTooltips();
});
