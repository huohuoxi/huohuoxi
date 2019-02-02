/*jslint browser: true */ /*global jQuery: true */

/**
* jQuery Cookie plugin
*
* Copyright (c) 2010 Klaus Hartl (stilbuero.de)
* Dual licensed under the MIT and GPL licenses:
* http://www.opensource.org/licenses/mit-license.php
* http://www.gnu.org/licenses/gpl.html
*
*/

// TODO JsDoc

/**
* Create a cookie with the given key and value and other optional parameters.
*
* @example $.cookie('the_cookie', 'the_value');
* @desc Set the value of a cookie.
* @example $.cookie('the_cookie', 'the_value', { expires: 7, path: '/', domain: 'jquery.com', secure: true });
* @desc Create a cookie with all available options.
* @example $.cookie('the_cookie', 'the_value');
* @desc Create a session cookie.
* @example $.cookie('the_cookie', null);
* @desc Delete a cookie by passing null as value. Keep in mind that you have to use the same path and domain
*       used when the cookie was set.
*
* @param String key The key of the cookie.
* @param String value The value of the cookie.
* @param Object options An object literal containing key/value pairs to provide optional cookie attributes.
* @option Number|Date expires Either an integer specifying the expiration date from now on in days or a Date object.
*                             If a negative value is specified (e.g. a date in the past), the cookie will be deleted.
*                             If set to null or omitted, the cookie will be a session cookie and will not be retained
*                             when the the browser exits.
* @option String path The value of the path atribute of the cookie (default: path of page that created the cookie).
* @option String domain The value of the domain attribute of the cookie (default: domain of page that created the cookie).
* @option Boolean secure If true, the secure attribute of the cookie will be set and the cookie transmission will
*                        require a secure protocol (like HTTPS).
* @type undefined
*
* @name $.cookie
* @cat Plugins/Cookie
* @author Klaus Hartl/klaus.hartl@stilbuero.de
*/

/**
* Get the value of a cookie with the given key.
*
* @example $.cookie('the_cookie');
* @desc Get the value of a cookie.
*
* @param String key The key of the cookie.
* @return The value of the cookie.
* @type String
*
* @name $.cookie
* @cat Plugins/Cookie
* @author Klaus Hartl/klaus.hartl@stilbuero.de
*/
jQuery.cookie = function (key, value, options) {

    // key and value given, set cookie...
    if (arguments.length > 1 && (value === null || typeof value !== "object")) {
        options = jQuery.extend({}, options);

        if (value === null) {
            options.expires = -1;
        }

        if (typeof options.expires === 'number') {
            var days = options.expires, t = options.expires = new Date();
            t.setDate(t.getDate() + days);
        }

        return (document.cookie = [
            encodeURIComponent(key), '=',
            options.raw ? String(value) : encodeURIComponent(String(value)),
            options.expires ? '; expires=' + options.expires.toUTCString() : '', // use expires attribute, max-age is not supported by IE
            options.path ? '; path=' + options.path : '',
            options.domain ? '; domain=' + options.domain : '',
            options.secure ? '; secure' : ''
        ].join(''));
    }

    // key and possibly options given, get cookie...
    options = value || {};
    var result, decode = options.raw ? function (s) { return s; } : decodeURIComponent;
    return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
};
/*!
* jQuery hashchange event - v1.3 - 7/21/2010
* http://benalman.com/projects/jquery-hashchange-plugin/
* 
* Copyright (c) 2010 "Cowboy" Ben Alman
* Dual licensed under the MIT and GPL licenses.
* http://benalman.com/about/license/
*/

// Script: jQuery hashchange event
//
// *Version: 1.3, Last updated: 7/21/2010*
// 
// Project Home - http://benalman.com/projects/jquery-hashchange-plugin/
// GitHub       - http://github.com/cowboy/jquery-hashchange/
// Source       - http://github.com/cowboy/jquery-hashchange/raw/master/jquery.ba-hashchange.js
// (Minified)   - http://github.com/cowboy/jquery-hashchange/raw/master/jquery.ba-hashchange.min.js (0.8kb gzipped)
// 
// About: License
// 
// Copyright (c) 2010 "Cowboy" Ben Alman,
// Dual licensed under the MIT and GPL licenses.
// http://benalman.com/about/license/
// 
// About: Examples
// 
// These working examples, complete with fully commented code, illustrate a few
// ways in which this plugin can be used.
// 
// hashchange event - http://benalman.com/code/projects/jquery-hashchange/examples/hashchange/
// document.domain - http://benalman.com/code/projects/jquery-hashchange/examples/document_domain/
// 
// About: Support and Testing
// 
// Information about what version or versions of jQuery this plugin has been
// tested with, what browsers it has been tested in, and where the unit tests
// reside (so you can test it yourself).
// 
// jQuery Versions - 1.2.6, 1.3.2, 1.4.1, 1.4.2
// Browsers Tested - Internet Explorer 6-8, Firefox 2-4, Chrome 5-6, Safari 3.2-5,
//                   Opera 9.6-10.60, iPhone 3.1, Android 1.6-2.2, BlackBerry 4.6-5.
// Unit Tests      - http://benalman.com/code/projects/jquery-hashchange/unit/
// 
// About: Known issues
// 
// While this jQuery hashchange event implementation is quite stable and
// robust, there are a few unfortunate browser bugs surrounding expected
// hashchange event-based behaviors, independent of any JavaScript
// window.onhashchange abstraction. See the following examples for more
// information:
// 
// Chrome: Back Button - http://benalman.com/code/projects/jquery-hashchange/examples/bug-chrome-back-button/
// Firefox: Remote XMLHttpRequest - http://benalman.com/code/projects/jquery-hashchange/examples/bug-firefox-remote-xhr/
// WebKit: Back Button in an Iframe - http://benalman.com/code/projects/jquery-hashchange/examples/bug-webkit-hash-iframe/
// Safari: Back Button from a different domain - http://benalman.com/code/projects/jquery-hashchange/examples/bug-safari-back-from-diff-domain/
// 
// Also note that should a browser natively support the window.onhashchange 
// event, but not report that it does, the fallback polling loop will be used.
// 
// About: Release History
// 
// 1.3   - (7/21/2010) Reorganized IE6/7 Iframe code to make it more
//         "removable" for mobile-only development. Added IE6/7 document.title
//         support. Attempted to make Iframe as hidden as possible by using
//         techniques from http://www.paciellogroup.com/blog/?p=604. Added 
//         support for the "shortcut" format $(window).hashchange( fn ) and
//         $(window).hashchange() like jQuery provides for built-in events.
//         Renamed jQuery.hashchangeDelay to <jQuery.fn.hashchange.delay> and
//         lowered its default value to 50. Added <jQuery.fn.hashchange.domain>
//         and <jQuery.fn.hashchange.src> properties plus document-domain.html
//         file to address access denied issues when setting document.domain in
//         IE6/7.
// 1.2   - (2/11/2010) Fixed a bug where coming back to a page using this plugin
//         from a page on another domain would cause an error in Safari 4. Also,
//         IE6/7 Iframe is now inserted after the body (this actually works),
//         which prevents the page from scrolling when the event is first bound.
//         Event can also now be bound before DOM ready, but it won't be usable
//         before then in IE6/7.
// 1.1   - (1/21/2010) Incorporated document.documentMode test to fix IE8 bug
//         where browser version is incorrectly reported as 8.0, despite
//         inclusion of the X-UA-Compatible IE=EmulateIE7 meta tag.
// 1.0   - (1/9/2010) Initial Release. Broke out the jQuery BBQ event.special
//         window.onhashchange functionality into a separate plugin for users
//         who want just the basic event & back button support, without all the
//         extra awesomeness that BBQ provides. This plugin will be included as
//         part of jQuery BBQ, but also be available separately.

(function ($, window, undefined) {
    '$:nomunge'; // Used by YUI compressor.

    // Reused string.
    var str_hashchange = 'hashchange',

    // Method / object references.
    doc = document,
    fake_onhashchange,
    special = $.event.special,

    // Does the browser support window.onhashchange? Note that IE8 running in
    // IE7 compatibility mode reports true for 'onhashchange' in window, even
    // though the event isn't supported, so also test document.documentMode.
    doc_mode = doc.documentMode,
    supports_onhashchange = 'on' + str_hashchange in window && (doc_mode === undefined || doc_mode > 7);

    // Get location.hash (or what you'd expect location.hash to be) sans any
    // leading #. Thanks for making this necessary, Firefox!
    function get_fragment(url) {
        url = url || location.href;
        return '#' + url.replace(/^[^#]*#?(.*)$/, '$1');
    };

    // Method: jQuery.fn.hashchange
    // 
    // Bind a handler to the window.onhashchange event or trigger all bound
    // window.onhashchange event handlers. This behavior is consistent with
    // jQuery's built-in event handlers.
    // 
    // Usage:
    // 
    // > jQuery(window).hashchange( [ handler ] );
    // 
    // Arguments:
    // 
    //  handler - (Function) Optional handler to be bound to the hashchange
    //    event. This is a "shortcut" for the more verbose form:
    //    jQuery(window).bind( 'hashchange', handler ). If handler is omitted,
    //    all bound window.onhashchange event handlers will be triggered. This
    //    is a shortcut for the more verbose
    //    jQuery(window).trigger( 'hashchange' ). These forms are described in
    //    the <hashchange event> section.
    // 
    // Returns:
    // 
    //  (jQuery) The initial jQuery collection of elements.

    // Allow the "shortcut" format $(elem).hashchange( fn ) for binding and
    // $(elem).hashchange() for triggering, like jQuery does for built-in events.
    $.fn[str_hashchange] = function (fn) {
        return fn ? this.bind(str_hashchange, fn) : this.trigger(str_hashchange);
    };

    // Property: jQuery.fn.hashchange.delay
    // 
    // The numeric interval (in milliseconds) at which the <hashchange event>
    // polling loop executes. Defaults to 50.

    // Property: jQuery.fn.hashchange.domain
    // 
    // If you're setting document.domain in your JavaScript, and you want hash
    // history to work in IE6/7, not only must this property be set, but you must
    // also set document.domain BEFORE jQuery is loaded into the page. This
    // property is only applicable if you are supporting IE6/7 (or IE8 operating
    // in "IE7 compatibility" mode).
    // 
    // In addition, the <jQuery.fn.hashchange.src> property must be set to the
    // path of the included "document-domain.html" file, which can be renamed or
    // modified if necessary (note that the document.domain specified must be the
    // same in both your main JavaScript as well as in this file).
    // 
    // Usage:
    // 
    // jQuery.fn.hashchange.domain = document.domain;

    // Property: jQuery.fn.hashchange.src
    // 
    // If, for some reason, you need to specify an Iframe src file (for example,
    // when setting document.domain as in <jQuery.fn.hashchange.domain>), you can
    // do so using this property. Note that when using this property, history
    // won't be recorded in IE6/7 until the Iframe src file loads. This property
    // is only applicable if you are supporting IE6/7 (or IE8 operating in "IE7
    // compatibility" mode).
    // 
    // Usage:
    // 
    // jQuery.fn.hashchange.src = 'path/to/file.html';

    $.fn[str_hashchange].delay = 50;
    /*
    $.fn[ str_hashchange ].domain = null;
    $.fn[ str_hashchange ].src = null;
    */

    // Event: hashchange event
    // 
    // Fired when location.hash changes. In browsers that support it, the native
    // HTML5 window.onhashchange event is used, otherwise a polling loop is
    // initialized, running every <jQuery.fn.hashchange.delay> milliseconds to
    // see if the hash has changed. In IE6/7 (and IE8 operating in "IE7
    // compatibility" mode), a hidden Iframe is created to allow the back button
    // and hash-based history to work.
    // 
    // Usage as described in <jQuery.fn.hashchange>:
    // 
    // > // Bind an event handler.
    // > jQuery(window).hashchange( function(e) {
    // >   var hash = location.hash;
    // >   ...
    // > });
    // > 
    // > // Manually trigger the event handler.
    // > jQuery(window).hashchange();
    // 
    // A more verbose usage that allows for event namespacing:
    // 
    // > // Bind an event handler.
    // > jQuery(window).bind( 'hashchange', function(e) {
    // >   var hash = location.hash;
    // >   ...
    // > });
    // > 
    // > // Manually trigger the event handler.
    // > jQuery(window).trigger( 'hashchange' );
    // 
    // Additional Notes:
    // 
    // * The polling loop and Iframe are not created until at least one handler
    //   is actually bound to the 'hashchange' event.
    // * If you need the bound handler(s) to execute immediately, in cases where
    //   a location.hash exists on page load, via bookmark or page refresh for
    //   example, use jQuery(window).hashchange() or the more verbose 
    //   jQuery(window).trigger( 'hashchange' ).
    // * The event can be bound before DOM ready, but since it won't be usable
    //   before then in IE6/7 (due to the necessary Iframe), recommended usage is
    //   to bind it inside a DOM ready handler.

    // Override existing $.event.special.hashchange methods (allowing this plugin
    // to be defined after jQuery BBQ in BBQ's source code).
    special[str_hashchange] = $.extend(special[str_hashchange], {

        // Called only when the first 'hashchange' event is bound to window.
        setup: function () {
            // If window.onhashchange is supported natively, there's nothing to do..
            if (supports_onhashchange) { return false; }

            // Otherwise, we need to create our own. And we don't want to call this
            // until the user binds to the event, just in case they never do, since it
            // will create a polling loop and possibly even a hidden Iframe.
            $(fake_onhashchange.start);
        },

        // Called only when the last 'hashchange' event is unbound from window.
        teardown: function () {
            // If window.onhashchange is supported natively, there's nothing to do..
            if (supports_onhashchange) { return false; }

            // Otherwise, we need to stop ours (if possible).
            $(fake_onhashchange.stop);
        }

    });

    // fake_onhashchange does all the work of triggering the window.onhashchange
    // event for browsers that don't natively support it, including creating a
    // polling loop to watch for hash changes and in IE 6/7 creating a hidden
    // Iframe to enable back and forward.
    fake_onhashchange = (function () {
        var self = {},
      timeout_id,

        // Remember the initial hash so it doesn't get triggered immediately.
      last_hash = get_fragment(),

      fn_retval = function (val) { return val; },
      history_set = fn_retval,
      history_get = fn_retval;

        // Start the polling loop.
        self.start = function () {
            timeout_id || poll();
        };

        // Stop the polling loop.
        self.stop = function () {
            timeout_id && clearTimeout(timeout_id);
            timeout_id = undefined;
        };

        // This polling loop checks every $.fn.hashchange.delay milliseconds to see
        // if location.hash has changed, and triggers the 'hashchange' event on
        // window when necessary.
        function poll() {
            var hash = get_fragment(),
        history_hash = history_get(last_hash);

            if (hash !== last_hash) {
                history_set(last_hash = hash, history_hash);

                $(window).trigger(str_hashchange);

            } else if (history_hash !== last_hash) {
                location.href = location.href.replace(/#.*/, '') + history_hash;
            }

            timeout_id = setTimeout(poll, $.fn[str_hashchange].delay);
        };

        // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
        // vvvvvvvvvvvvvvvvvvv REMOVE IF NOT SUPPORTING IE6/7/8 vvvvvvvvvvvvvvvvvvv
        // vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
        $.browser.msie && !supports_onhashchange && (function () {
            // Not only do IE6/7 need the "magical" Iframe treatment, but so does IE8
            // when running in "IE7 compatibility" mode.

            var iframe,
        iframe_src;

            // When the event is bound and polling starts in IE 6/7, create a hidden
            // Iframe for history handling.
            self.start = function () {
                if (!iframe) {
                    iframe_src = $.fn[str_hashchange].src;
                    iframe_src = iframe_src && iframe_src + get_fragment();

                    // Create hidden Iframe. Attempt to make Iframe as hidden as possible
                    // by using techniques from http://www.paciellogroup.com/blog/?p=604.
                    iframe = $('<iframe tabindex="-1" title="empty"/>').hide()

                    // When Iframe has completely loaded, initialize the history and
                    // start polling.
            .one('load', function () {
                iframe_src || history_set(get_fragment());
                poll();
            })

                    // Load Iframe src if specified, otherwise nothing.
            .attr('src', iframe_src || 'javascript:0')

                    // Append Iframe after the end of the body to prevent unnecessary
                    // initial page scrolling (yes, this works).
            .insertAfter('body')[0].contentWindow;

                    // Whenever `document.title` changes, update the Iframe's title to
                    // prettify the back/next history menu entries. Since IE sometimes
                    // errors with "Unspecified error" the very first time this is set
                    // (yes, very useful) wrap this with a try/catch block.
                    doc.onpropertychange = function () {
                        try {
                            if (event.propertyName === 'title') {
                                iframe.document.title = doc.title;
                            }
                        } catch (e) { }
                    };

                }
            };

            // Override the "stop" method since an IE6/7 Iframe was created. Even
            // if there are no longer any bound event handlers, the polling loop
            // is still necessary for back/next to work at all!
            self.stop = fn_retval;

            // Get history by looking at the hidden Iframe's location.hash.
            history_get = function () {
                return get_fragment(iframe.location.href);
            };

            // Set a new history item by opening and then closing the Iframe
            // document, *then* setting its location.hash. If document.domain has
            // been set, update that as well.
            history_set = function (hash, history_hash) {
                var iframe_doc = iframe.document,
          domain = $.fn[str_hashchange].domain;

                if (hash !== history_hash) {
                    // Update Iframe with any initial `document.title` that might be set.
                    iframe_doc.title = doc.title;

                    // Opening the Iframe's document after it has been closed is what
                    // actually adds a history entry.
                    iframe_doc.open();

                    // Set document.domain for the Iframe document as well, if necessary.
                    domain && iframe_doc.write('<script>document.domain="' + domain + '"</script>');

                    iframe_doc.close();

                    // Update the Iframe's hash, for great justice.
                    iframe.location.hash = hash;
                }
            };

        })();
        // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        // ^^^^^^^^^^^^^^^^^^^ REMOVE IF NOT SUPPORTING IE6/7/8 ^^^^^^^^^^^^^^^^^^^
        // ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

        return self;
    })();

})(jQuery, this);
/*
json2.js
2008-03-14

Public Domain

No warranty expressed or implied. Use at your own risk.

See http://www.JSON.org/js.html

This file creates a global JSON object containing two methods:

JSON.stringify(value, whitelist)
value       any JavaScript value, usually an object or array.

whitelist   an optional array parameter that determines how object
values are stringified.

This method produces a JSON text from a JavaScript value.
There are three possible ways to stringify an object, depending
on the optional whitelist parameter.

If an object has a toJSON method, then the toJSON() method will be
called. The value returned from the toJSON method will be
stringified.

Otherwise, if the optional whitelist parameter is an array, then
the elements of the array will be used to select members of the
object for stringification.

Otherwise, if there is no whitelist parameter, then all of the
members of the object will be stringified.

Values that do not have JSON representaions, such as undefined or
functions, will not be serialized. Such values in objects will be
dropped; in arrays will be replaced with null.
JSON.stringify(undefined) returns undefined. Dates will be
stringified as quoted ISO dates.

Example:

var text = JSON.stringify(['e', {pluribus: 'unum'}]);
// text is '["e",{"pluribus":"unum"}]'

JSON.parse(text, filter)
This method parses a JSON text to produce an object or
array. It can throw a SyntaxError exception.

The optional filter parameter is a function that can filter and
transform the results. It receives each of the keys and values, and
its return value is used instead of the original value. If it
returns what it received, then structure is not modified. If it
returns undefined then the member is deleted.

Example:

// Parse the text. If a key contains the string 'date' then
// convert the value to a date.

myData = JSON.parse(text, function (key, value) {
return key.indexOf('date') >= 0 ? new Date(value) : value;
});

This is a reference implementation. You are free to copy, modify, or
redistribute.

Use your own copy. It is extremely unwise to load third party
code into your pages.
*/

/*jslint evil: true */

/*global JSON */

/*members "\b", "\t", "\n", "\f", "\r", "\"", JSON, "\\", apply,
charCodeAt, floor, getUTCDate, getUTCFullYear, getUTCHours,
getUTCMinutes, getUTCMonth, getUTCSeconds, hasOwnProperty, join, length,
parse, propertyIsEnumerable, prototype, push, replace, stringify, test,
toJSON, toString
*/

if (!this.JSON) {

    JSON = function () {

        function f(n) {    // Format integers to have at least two digits.
            return n < 10 ? '0' + n : n;
        }

        Date.prototype.toJSON = function () {

            // Eventually, this method will be based on the date.toISOString method.

            return this.getUTCFullYear() + '-' +
                 f(this.getUTCMonth() + 1) + '-' +
                 f(this.getUTCDate()) + 'T' +
                 f(this.getUTCHours()) + ':' +
                 f(this.getUTCMinutes()) + ':' +
                 f(this.getUTCSeconds()) + 'Z';
        };


        var m = {    // table of character substitutions
            '\b': '\\b',
            '\t': '\\t',
            '\n': '\\n',
            '\f': '\\f',
            '\r': '\\r',
            '"': '\\"',
            '\\': '\\\\'
        };

        function stringify(value, whitelist) {
            var a,          // The array holding the partial texts.
                i,          // The loop counter.
                k,          // The member key.
                l,          // Length.
                r = /["\\\x00-\x1f\x7f-\x9f]/g,
                v;          // The member value.

            switch (typeof value) {
                case 'string':

                    // If the string contains no control characters, no quote characters, and no
                    // backslash characters, then we can safely slap some quotes around it.
                    // Otherwise we must also replace the offending characters with safe sequences.

                    return r.test(value) ?
                    '"' + value.replace(r, function (a) {
                        var c = m[a];
                        if (c) {
                            return c;
                        }
                        c = a.charCodeAt();
                        return '\\u00' + Math.floor(c / 16).toString(16) +
                                                   (c % 16).toString(16);
                    }) + '"' :
                    '"' + value + '"';

                case 'number':

                    // JSON numbers must be finite. Encode non-finite numbers as null.

                    return isFinite(value) ? String(value) : 'null';

                case 'boolean':
                case 'null':
                    return String(value);

                case 'object':

                    // Due to a specification blunder in ECMAScript,
                    // typeof null is 'object', so watch out for that case.

                    if (!value) {
                        return 'null';
                    }

                    // If the object has a toJSON method, call it, and stringify the result.

                    if (typeof value.toJSON === 'function') {
                        return stringify(value.toJSON());
                    }
                    a = [];
                    if (typeof value.length === 'number' &&
                        !(value.propertyIsEnumerable('length'))) {

                        // The object is an array. Stringify every element. Use null as a placeholder
                        // for non-JSON values.

                        l = value.length;
                        for (i = 0; i < l; i += 1) {
                            a.push(stringify(value[i], whitelist) || 'null');
                        }

                        // Join all of the elements together and wrap them in brackets.

                        return '[' + a.join(',') + ']';
                    }
                    if (whitelist) {

                        // If a whitelist (array of keys) is provided, use it to select the components
                        // of the object.

                        l = whitelist.length;
                        for (i = 0; i < l; i += 1) {
                            k = whitelist[i];
                            if (typeof k === 'string') {
                                v = stringify(value[k], whitelist);
                                if (v) {
                                    a.push(stringify(k) + ':' + v);
                                }
                            }
                        }
                    } else {

                        // Otherwise, iterate through all of the keys in the object.

                        for (k in value) {
                            if (typeof k === 'string') {
                                v = stringify(value[k], whitelist);
                                if (v) {
                                    a.push(stringify(k) + ':' + v);
                                }
                            }
                        }
                    }

                    // Join all of the member texts together and wrap them in braces.

                    return '{' + a.join(',') + '}';
            }
        }

        return {
            stringify: stringify,
            parse: function (text, filter) {
                var j;

                function walk(k, v) {
                    var i, n;
                    if (v && typeof v === 'object') {
                        for (i in v) {
                            if (Object.prototype.hasOwnProperty.apply(v, [i])) {
                                n = walk(i, v[i]);
                                if (n !== undefined) {
                                    v[i] = n;
                                } else {
                                    delete v[i];
                                }
                            }
                        }
                    }
                    return filter(k, v);
                }


                // Parsing happens in three stages. In the first stage, we run the text against
                // regular expressions that look for non-JSON patterns. We are especially
                // concerned with '()' and 'new' because they can cause invocation, and '='
                // because it can cause mutation. But just to be safe, we want to reject all
                // unexpected forms.

                // We split the first stage into 4 regexp operations in order to work around
                // crippling inefficiencies in IE's and Safari's regexp engines. First we
                // replace all backslash pairs with '@' (a non-JSON character). Second, we
                // replace all simple value tokens with ']' characters. Third, we delete all
                // open brackets that follow a colon or comma or that begin the text. Finally,
                // we look to see that the remaining characters are only whitespace or ']' or
                // ',' or ':' or '{' or '}'. If that is so, then the text is safe for eval.

                if (/^[\],:{}\s]*$/.test(text.replace(/\\["\\\/bfnrtu]/g, '@').
replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']').
replace(/(?:^|:|,)(?:\s*\[)+/g, ''))) {

                    // In the second stage we use the eval function to compile the text into a
                    // JavaScript structure. The '{' operator is subject to a syntactic ambiguity
                    // in JavaScript: it can begin a block or an object literal. We wrap the text
                    // in parens to eliminate the ambiguity.

                    j = eval('(' + text + ')');

                    // In the optional third stage, we recursively walk the new structure, passing
                    // each name/value pair to a filter function for possible transformation.

                    return typeof filter === 'function' ? walk('', j) : j;
                }

                // If the text is not JSON parseable, then a SyntaxError is thrown.

                throw new SyntaxError('parseJSON');
            }
        };
    }();
};
/* ajax manager */
function handleException(result, callback_on_exception) {
    if (result == null || !result.__AjaxException)
        return result;

    var exc = result.__AjaxException;

    if (callback_on_exception && $.isFunction(callback_on_exception)) {
        result = null;

        callback_on_exception.apply(exc, []);

        return;
    }

    if (exc.action == "JSMethod") {
        result = null;
        eval(exc.parameter + "()");
    }
    else if (exc.action == "JSEval") {
        result = null;
        eval(exc.parameter);
    }
    else if (exc.action == "returnValue") {
        return exc.parameter;
    }
};

function AjaxManager() { }

AjaxManager.prototype = {
    initialize: function () { },
    getData: function (classId, methodName, args, ajaxType, callbackMethod, ajaxUrl) {
        var result = null;
        var asyncCall = false;
        if (callbackMethod && typeof callbackMethod == "function") {
            asyncCall = true;
        }

        $.ajax({
            type: ajaxType || 'Post',
            url: ajaxUrl || "/ajax.aspx",
            async: asyncCall,
            dataType: 'json',
            data: "classId=" + encodeURIComponent(classId) +
						"&methodName=" + encodeURIComponent(methodName) +
						"&methodArgs=" + encodeURIComponent(JSON.stringify(args)) +
						"&querystring=" + encodeURIComponent(window.location.search),
            success: function (e) {
                result = handleException(e);

                if (callbackMethod && result != undefined) {
                    callbackMethod(result);
                }
            },
            error: function (e) {
                result = handleException(e);
                if (!result) {
                    result = e.responseText;
                }
                if (callbackMethod && result != undefined) {
                    callbackMethod(result);
                }
            }
        });
        return result;
    }
};
var __ajaxManager = new AjaxManager();
/**
* jQuery.query - Query String Modification and Creation for jQuery
* Written by Blair Mitchelmore (blair DOT mitchelmore AT gmail DOT com)
* Licensed under the WTFPL (http://sam.zoy.org/wtfpl/).
* Date: 2009/8/13
*
* @author Blair Mitchelmore
* @version 2.1.7
*
**/
new function (settings) {
    // Various Settings
    var $separator = settings.separator || '&';
    var $spaces = settings.spaces === false ? false : true;
    var $suffix = settings.suffix === false ? '' : '[]';
    var $prefix = settings.prefix === false ? false : true;
    var $hash = $prefix ? settings.hash === true ? "#" : "?" : "";
    var $numbers = settings.numbers ? true : false;

    jQuery.query = new function () {
        var is = function (o, t) {
            return o != undefined && o !== null && (!!t ? o.constructor == t : true);
        };
        var parse = function (path) {
            var m, rx = /\[([^[]*)\]/g, match = /^([^[]+)(\[.*\])?$/.exec(path), base = match[1], tokens = [];
            while (m = rx.exec(match[2])) tokens.push(m[1]);
            return [base, tokens];
        };
        var set = function (target, tokens, value) {
            var o, token = tokens.shift();
            if (typeof target != 'object') target = null;
            if (token === "") {
                if (!target) target = [];
                if (is(target, Array)) {
                    target.push(tokens.length == 0 ? value : set(null, tokens.slice(0), value));
                } else if (is(target, Object)) {
                    var i = 0;
                    while (target[i++] != null);
                    target[--i] = tokens.length == 0 ? value : set(target[i], tokens.slice(0), value);
                } else {
                    target = [];
                    target.push(tokens.length == 0 ? value : set(null, tokens.slice(0), value));
                }
            } else if (token && token.match(/^\s*[0-9]+\s*$/)) {
                var index = parseInt(token, 10);
                if (!target) target = [];
                target[index] = tokens.length == 0 ? value : set(target[index], tokens.slice(0), value);
            } else if (token) {
                var index = token.replace(/^\s*|\s*$/g, "");
                if (!target) target = {};
                if (is(target, Array)) {
                    var temp = {};
                    for (var i = 0; i < target.length; ++i) {
                        temp[i] = target[i];
                    }
                    target = temp;
                }
                target[index] = tokens.length == 0 ? value : set(target[index], tokens.slice(0), value);
            } else {
                return value;
            }
            return target;
        };

        var queryObject = function (a) {
            var self = this;
            self.keys = {};

            if (a.queryObject) {
                jQuery.each(a.get(), function (key, val) {
                    self.SET(key, val);
                });
            } else {
                jQuery.each(arguments, function () {
                    var q = "" + this;
                    q = q.replace(/^[?#]/, ''); // remove any leading ? || #
                    q = q.replace(/[;&]$/, ''); // remove any trailing & || ;
                    if ($spaces) q = q.replace(/[+]/g, ' '); // replace +'s with spaces

                    jQuery.each(q.split(/[&;]/), function () {
                        var key = decodeURIComponent(this.split('=')[0] || "");
                        var val = decodeURIComponent(this.split('=')[1] || "");

                        if (!key) return;

                        if ($numbers) {
                            if (/^[+-]?[0-9]+\.[0-9]*$/.test(val)) // simple float regex
                                val = parseFloat(val);
                            else if (/^[+-]?[0-9]+$/.test(val)) // simple int regex
                                val = parseInt(val, 10);
                        }

                        val = (!val && val !== 0) ? true : val;

                        if (val !== false && val !== true && typeof val != 'number')
                            val = val;

                        self.SET(key, val);
                    });
                });
            }
            return self;
        };

        queryObject.prototype = {
            queryObject: true,
            has: function (key, type) {
                var value = this.get(key);
                return is(value, type);
            },
            GET: function (key) {
                if (!is(key)) return this.keys;
                var parsed = parse(key), base = parsed[0], tokens = parsed[1];
                var target = this.keys[base];
                while (target != null && tokens.length != 0) {
                    target = target[tokens.shift()];
                }
                return typeof target == 'number' ? target : target || "";
            },
            get: function (key) {
                var target = this.GET(key);
                if (is(target, Object))
                    return jQuery.extend(true, {}, target);
                else if (is(target, Array))
                    return target.slice(0);
                return target;
            },
            SET: function (key, val) {
                var value = !is(val) ? null : val;
                var parsed = parse(key), base = parsed[0], tokens = parsed[1];
                var target = this.keys[base];
                this.keys[base] = set(target, tokens.slice(0), value);
                return this;
            },
            set: function (key, val) {
                return this.copy().SET(key, val);
            },
            REMOVE: function (key) {
                return this.SET(key, null).COMPACT();
            },
            remove: function (key) {
                return this.copy().REMOVE(key);
            },
            EMPTY: function () {
                var self = this;
                jQuery.each(self.keys, function (key, value) {
                    delete self.keys[key];
                });
                return self;
            },
            load: function (url) {
                var hash = url.replace(/^.*?[#](.+?)(?:\?.+)?$/, "$1");
                var search = url.replace(/^.*?[?](.+?)(?:#.+)?$/, "$1");
                return new queryObject(url.length == search.length ? '' : search, url.length == hash.length ? '' : hash);
            },
            empty: function () {
                return this.copy().EMPTY();
            },
            copy: function () {
                return new queryObject(this);
            },
            COMPACT: function () {
                function build(orig) {
                    var obj = typeof orig == "object" ? is(orig, Array) ? [] : {} : orig;
                    if (typeof orig == 'object') {
                        function add(o, key, value) {
                            if (is(o, Array))
                                o.push(value);
                            else
                                o[key] = value;
                        }
                        jQuery.each(orig, function (key, value) {
                            if (!is(value)) return true;
                            add(obj, key, build(value));
                        });
                    }
                    return obj;
                }
                this.keys = build(this.keys);
                return this;
            },
            compact: function () {
                return this.copy().COMPACT();
            },
            toString: function () {
                var i = 0, queryString = [], chunks = [], self = this;
                var encode = function (str) {
                    str = str + "";
                    //if ($spaces) str = str.replace(/ /g, "+");
                    return encodeURIComponent(str);
                };
                var addFields = function (arr, key, value) {
                    if (!is(value) || value === false) return;
                    var o = [encode(key)];
                    if (value !== true) {
                        o.push("=");
                        o.push(encode(value));
                    }
                    arr.push(o.join(""));
                };
                var build = function (obj, base) {
                    var newKey = function (key) {
                        return !base || base == "" ? [key].join("") : [base, "[", key, "]"].join("");
                    };
                    jQuery.each(obj, function (key, value) {
                        if (typeof value == 'object')
                            build(value, newKey(key));
                        else
                            addFields(chunks, newKey(key), value);
                    });
                };

                build(this.keys);

                if (chunks.length > 0) queryString.push($hash);
                queryString.push(chunks.join($separator));

                return queryString.join("");
            }
        };

        return new queryObject(location.search, location.hash);
    };
}(jQuery.query || {});

/*
*JS文件动态加载工具
*/
var LazyInclude = {
    scripts: [],
    loadScript: function (url, callback) {
        var script = this.scripts[url] || (this.scripts[url] = {
            loaded: false,
            callbacks: []
        });

        if (script.loaded) {
            return callback.apply();
        }

        script.callbacks.push({
            fn: callback
        });

        if (script.callbacks.length == 1) {
            $.ajax({
                type: 'GET',
                url: url,
                dataType: 'script',
                cache: true,
                success: function () {
                    script.loaded = true;
                    $.each(script.callbacks, function () {
                        this.fn.apply();
                    });
                    script.callbacks.length = 0;
                }
            });
        }
    },
    call: (function () {
        function hasFile(tag, url) {
            var contains = false;
            var type = (tag == "script") ? "src" : "href";

            $(tag + '[' + type + ']').each(function (i, v) {
                var attr = $(v).attr(type)
                if (attr == url || decodeURIComponent(attr).indexOf(url) != -1) {
                    contains = true;
                    return false;
                }
            });

            return contains;
        }

        function loadCssFile(files) {
            var urls = files && typeof (files) == "string" ? [files] : files;

            for (var i = 0; i < urls.length; i++) {
                if (!hasFile("link", urls[i])) {
                    var ele = document.createElement("link");
                    ele.setAttribute('type', 'text/css');
                    ele.setAttribute('rel', 'stylesheet');
                    ele.setAttribute('href', urls[i]);

                    document.getElementsByTagName('head')[0].appendChild(ele);
                }
            }
        }

        function loadScript(files) {

            if (!$.isArray(files)) {
                return LazyInclude.loadScript(files.url, files.cb);
            }

            var counter = 0;

            // parallel loading
            return $.each(files, function (i, v) {
                LazyInclude.loadScript(v.url, v.cb);
            });
        }

        function includeFile(opts) {
            //首先加载css
            loadCssFile(opts.cssFiles);
            //加载js                 
            loadScript(opts.jsFiles);
        }
        return { include: includeFile };
    })()
};

var lazy_include = function (opts) {
    LazyInclude.call.include(opts);
};

function handleException(result) {
    if (result == null || !result.__AjaxException)
        return result;

    var exc = result.__AjaxException;
    if (exc.action == "JSMethod") {
        result = null;
        eval(exc.parameter + "()");
    }
    else if (exc.action == "JSEval") {
        result = null;
        eval(exc.parameter);
    }
    else if (exc.action == "returnValue") {
        return exc.parameter;
    }
};

var lazy_embed = function (options) {
    window.lazy_embed_data = options;

    if ($('body').data('binded')) {
        $(window).hashchange();
        return;
    }

    lazy_include({
        jsFiles: [{
            url: (options.vp || '/') + '_res.aspx?r=alF1ZXJ5Lmhhc2guanM=&t=&z=1&v=1&su=1', cb: function () {

                $('body').data('binded', true);

                $(window).hashchange(function () {
                    var opts = window.lazy_embed_data;

                    var url = opts.url;
                    if (window.location.hash) {
                        url = window.location.hash.substr(1);

                        if (url.indexOf('?') == 0) {
                            if (opts.url.indexOf('?') == -1)
                                url = opts.url + url;
                            else
                                url = opts.url + '&' + url.substr(1);
                        }
                    }

                    jQuery.ajax({
                        headers: { 'embed': '1', 'embedUrl': (opts.affect_url || ''), 'usedinmvc': opts.usedinmvc },
                        dataType: 'json',
                        url: url,
                        success: function (data) {
                            data = handleException(data);

                            opts.container.empty().html(data);

                            if (opts.callback && jQuery.isFunction(opts.callback)) {
                                opts.callback.apply();
                            }
                        },
                        error: function () { }
                    });
                });

                $(window).hashchange();
            }
        }],
        cssFiles: []
    });
};
/*!
* jQuery Form Plugin
* version: 2.94 (13-DEC-2011)
* @requires jQuery v1.3.2 or later
*
* Examples and documentation at: http://malsup.com/jquery/form/
* Dual licensed under the MIT and GPL licenses:
*	http://www.opensource.org/licenses/mit-license.php
*	http://www.gnu.org/licenses/gpl.html
*/
; (function ($) {

    /*
	Usage Note:
	-----------
	Do not use both ajaxSubmit and ajaxForm on the same form.  These
	functions are intended to be exclusive.  Use ajaxSubmit if you want
	to bind your own submit handler to the form.  For example,

	$(document).ready(function() {
	$('#myForm').bind('submit', function(e) {
	e.preventDefault(); // <-- important
	$(this).ajaxSubmit({
	target: '#output'
	});
	});
	});

	Use ajaxForm when you want the plugin to manage all the event binding
	for you.  For example,

	$(document).ready(function() {
	$('#myForm').ajaxForm({
	target: '#output'
	});
	});

	When using ajaxForm, the ajaxSubmit function will be invoked for you
	at the appropriate time.
	*/

    /**
	* ajaxSubmit() provides a mechanism for immediately submitting
	* an HTML form using AJAX.
	*/
    $.fn.ajaxSubmit = function (options) {
        // fast fail if nothing selected (http://dev.jquery.com/ticket/2752)
        if (!this.length) {
            log('ajaxSubmit: skipping submit process - no element selected');
            return this;
        }

        var method, action, url, $form = this;

        if (typeof options == 'function') {
            options = { success: options };
        }

        method = this.attr('method');
        action = this.attr('action');
        url = (typeof action === 'string') ? $.trim(action) : '';
        url = url || window.location.href || '';
        if (url) {
            // clean url (don't include hash vaue)
            url = (url.match(/^([^#]+)/) || [])[1];
        }

        options = $.extend(true, {
            url: url,
            success: $.ajaxSettings.success,
            type: method || 'GET',
            iframeSrc: /^https/i.test(window.location.href || '') ? 'javascript:false' : 'about:blank'
        }, options);

        // hook for manipulating the form data before it is extracted;
        // convenient for use with rich editors like tinyMCE or FCKEditor
        var veto = {};
        this.trigger('form-pre-serialize', [this, options, veto]);
        if (veto.veto) {
            log('ajaxSubmit: submit vetoed via form-pre-serialize trigger');
            return this;
        }

        // provide opportunity to alter form data before it is serialized
        if (options.beforeSerialize && options.beforeSerialize(this, options) === false) {
            log('ajaxSubmit: submit aborted via beforeSerialize callback');
            return this;
        }

        var traditional = options.traditional;
        if (traditional === undefined) {
            traditional = $.ajaxSettings.traditional;
        }

        var qx, n, v, a = this.formToArray(options.semantic);
        if (options.data) {
            options.extraData = options.data;
            qx = $.param(options.data, traditional);
        }

        // give pre-submit callback an opportunity to abort the submit
        if (options.beforeSubmit && options.beforeSubmit(a, this, options) === false) {
            log('ajaxSubmit: submit aborted via beforeSubmit callback');
            return this;
        }

        // fire vetoable 'validate' event
        this.trigger('form-submit-validate', [a, this, options, veto]);
        if (veto.veto) {
            log('ajaxSubmit: submit vetoed via form-submit-validate trigger');
            return this;
        }

        var q = $.param(a, traditional);
        if (qx) {
            q = (q ? (q + '&' + qx) : qx);
        }
        if (options.type.toUpperCase() == 'GET') {
            options.url += (options.url.indexOf('?') >= 0 ? '&' : '?') + q;
            options.data = null;  // data is null for 'get'
        }
        else {
            options.data = q; // data is the query string for 'post'
        }

        var callbacks = [];
        if (options.resetForm) {
            callbacks.push(function () { $form.resetForm(); });
        }
        if (options.clearForm) {
            callbacks.push(function () { $form.clearForm(options.includeHidden); });
        }

        // perform a load on the target only if dataType is not provided
        if (!options.dataType && options.target) {
            var oldSuccess = options.success || function () { };
            callbacks.push(function (data) {
                var fn = options.replaceTarget ? 'replaceWith' : 'html';
                $(options.target)[fn](data).each(oldSuccess, arguments);
            });
        }
        else if (options.success) {
            callbacks.push(options.success);
        }

        options.success = function (data, status, xhr) { // jQuery 1.4+ passes xhr as 3rd arg
            var context = options.context || options; // jQuery 1.4+ supports scope context 
            for (var i = 0, max = callbacks.length; i < max; i++) {
                callbacks[i].apply(context, [data, status, xhr || $form, $form]);
            }
        };

        // are there files to upload?
        var fileInputs = $('input:file:enabled[value]', this); // [value] (issue #113)
        var hasFileInputs = fileInputs.length > 0;
        var mp = 'multipart/form-data';
        var multipart = ($form.attr('enctype') == mp || $form.attr('encoding') == mp);

        var fileAPI = !!(hasFileInputs && fileInputs.get(0).files && window.FormData);
        log("fileAPI :" + fileAPI);
        var shouldUseFrame = (hasFileInputs || multipart) && !fileAPI;

        // options.iframe allows user to force iframe mode
        // 06-NOV-09: now defaulting to iframe mode if file input is detected
        if (options.iframe !== false && (options.iframe || shouldUseFrame)) {
            // hack to fix Safari hang (thanks to Tim Molendijk for this)
            // see:  http://groups.google.com/group/jquery-dev/browse_thread/thread/36395b7ab510dd5d
            if (options.closeKeepAlive) {
                $.get(options.closeKeepAlive, function () {
                    fileUploadIframe(a);
                });
            }
            else {
                fileUploadIframe(a);
            }
        }
        else if ((hasFileInputs || multipart) && fileAPI) {
            options.progress = options.progress || $.noop;
            fileUploadXhr(a);
        }
        else {
            $.ajax(options);
        }

        // fire 'notify' event
        this.trigger('form-submit-notify', [this, options]);
        return this;

        // XMLHttpRequest Level 2 file uploads (big hat tip to francois2metz)
        function fileUploadXhr(a) {
            var formdata = new FormData();

            for (var i = 0; i < a.length; i++) {
                if (a[i].type == 'file')
                    continue;
                formdata.append(a[i].name, a[i].value);
            }

            $form.find('input:file:enabled').each(function () {
                var name = $(this).attr('name'), files = this.files;
                if (name) {
                    for (var i = 0; i < files.length; i++)
                        formdata.append(name, files[i]);
                }
            });

            if (options.extraData) {
                for (var k in options.extraData)
                    formdata.append(k, options.extraData[k])
            }

            options.data = null;

            var s = $.extend(true, {}, $.ajaxSettings, options, {
                contentType: false,
                processData: false,
                cache: false,
                type: 'POST'
            });

            s.context = s.context || s;

            s.data = null;
            var beforeSend = s.beforeSend;
            s.beforeSend = function (xhr, o) {
                o.data = formdata;
                if (xhr.upload) { // unfortunately, jQuery doesn't expose this prop (http://bugs.jquery.com/ticket/10190)
                    xhr.upload.onprogress = function (event) {
                        o.progress(event.position, event.total);
                    };
                }
                if (beforeSend)
                    beforeSend.call(o, xhr, options);
            };
            $.ajax(s);
        }

        // private function for handling file uploads (hat tip to YAHOO!)
        function fileUploadIframe(a) {
            var form = $form[0], el, i, s, g, id, $io, io, xhr, sub, n, timedOut, timeoutHandle;
            var useProp = !!$.fn.prop;

            if (a) {
                if (useProp) {
                    // ensure that every serialized input is still enabled
                    for (i = 0; i < a.length; i++) {
                        el = $(form[a[i].name]);
                        el.prop('disabled', false);
                    }
                } else {
                    for (i = 0; i < a.length; i++) {
                        el = $(form[a[i].name]);
                        el.removeAttr('disabled');
                    }
                };
            }

            if ($(':input[name=submit],:input[id=submit]', form).length) {
                // if there is an input with a name or id of 'submit' then we won't be
                // able to invoke the submit fn on the form (at least not x-browser)
                alert('Error: Form elements must not have name or id of "submit".');
                return;
            }

            s = $.extend(true, {}, $.ajaxSettings, options);
            s.context = s.context || s;
            id = 'jqFormIO' + (new Date().getTime());
            if (s.iframeTarget) {
                $io = $(s.iframeTarget);
                n = $io.attr('name');
                if (n == null)
                    $io.attr('name', id);
                else
                    id = n;
            }
            else {
                $io = $('<iframe name="' + id + '" src="' + s.iframeSrc + '" />');
                $io.css({ position: 'absolute', top: '-1000px', left: '-1000px' });
            }
            io = $io[0];


            xhr = { // mock object
                aborted: 0,
                responseText: null,
                responseXML: null,
                status: 0,
                statusText: 'n/a',
                getAllResponseHeaders: function () { },
                getResponseHeader: function () { },
                setRequestHeader: function () { },
                abort: function (status) {
                    var e = (status === 'timeout' ? 'timeout' : 'aborted');
                    log('aborting upload... ' + e);
                    this.aborted = 1;
                    $io.attr('src', s.iframeSrc); // abort op in progress
                    xhr.error = e;
                    s.error && s.error.call(s.context, xhr, e, status);
                    g && $.event.trigger("ajaxError", [xhr, s, e]);
                    s.complete && s.complete.call(s.context, xhr, e);
                }
            };

            g = s.global;
            // trigger ajax global events so that activity/block indicators work like normal
            if (g && !$.active++) {
                $.event.trigger("ajaxStart");
            }
            if (g) {
                $.event.trigger("ajaxSend", [xhr, s]);
            }

            if (s.beforeSend && s.beforeSend.call(s.context, xhr, s) === false) {
                if (s.global) {
                    $.active--;
                }
                return;
            }
            if (xhr.aborted) {
                return;
            }

            // add submitting element to data if we know it
            sub = form.clk;
            if (sub) {
                n = sub.name;
                if (n && !sub.disabled) {
                    s.extraData = s.extraData || {};
                    s.extraData[n] = sub.value;
                    if (sub.type == "image") {
                        s.extraData[n + '.x'] = form.clk_x;
                        s.extraData[n + '.y'] = form.clk_y;
                    }
                }
            }

            var CLIENT_TIMEOUT_ABORT = 1;
            var SERVER_ABORT = 2;

            function getDoc(frame) {
                var doc = frame.contentWindow ? frame.contentWindow.document : frame.contentDocument ? frame.contentDocument : frame.document;
                return doc;
            }

            // Rails CSRF hack (thanks to Yvan Barthelemy)
            var csrf_token = $('meta[name=csrf-token]').attr('content');
            var csrf_param = $('meta[name=csrf-param]').attr('content');
            if (csrf_param && csrf_token) {
                s.extraData = s.extraData || {};
                s.extraData[csrf_param] = csrf_token;
            }

            // take a breath so that pending repaints get some cpu time before the upload starts
            function doSubmit() {
                // make sure form attrs are set
                var t = $form.attr('target'), a = $form.attr('action');

                // update form attrs in IE friendly way
                form.setAttribute('target', id);
                if (!method) {
                    form.setAttribute('method', 'POST');
                }
                if (a != s.url) {
                    form.setAttribute('action', s.url);
                }

                // ie borks in some cases when setting encoding
                if (!s.skipEncodingOverride && (!method || /post/i.test(method))) {
                    $form.attr({
                        encoding: 'multipart/form-data',
                        enctype: 'multipart/form-data'
                    });
                }

                // support timout
                if (s.timeout) {
                    timeoutHandle = setTimeout(function () { timedOut = true; cb(CLIENT_TIMEOUT_ABORT); }, s.timeout);
                }

                // look for server aborts
                function checkState() {
                    try {
                        var state = getDoc(io).readyState;
                        log('state = ' + state);
                        if (state.toLowerCase() == 'uninitialized')
                            setTimeout(checkState, 50);
                    }
                    catch (e) {
                        log('Server abort: ', e, ' (', e.name, ')');
                        cb(SERVER_ABORT);
                        timeoutHandle && clearTimeout(timeoutHandle);
                        timeoutHandle = undefined;
                    }
                }

                // add "extra" data to form if provided in options
                var extraInputs = [];
                try {
                    if (s.extraData) {
                        for (var n in s.extraData) {
                            extraInputs.push(
							$('<input type="hidden" name="' + n + '">').attr('value', s.extraData[n])
								.appendTo(form)[0]);
                        }
                    }

                    if (!s.iframeTarget) {
                        // add iframe to doc and submit the form
                        $io.appendTo('body');
                        io.attachEvent ? io.attachEvent('onload', cb) : io.addEventListener('load', cb, false);
                    }
                    setTimeout(checkState, 15);
                    form.submit();
                }
                finally {
                    // reset attrs and remove "extra" input elements
                    form.setAttribute('action', a);
                    if (t) {
                        form.setAttribute('target', t);
                    } else {
                        $form.removeAttr('target');
                    }
                    $(extraInputs).remove();
                }
            }

            if (s.forceSync) {
                doSubmit();
            }
            else {
                setTimeout(doSubmit, 10); // this lets dom updates render
            }

            var data, doc, domCheckCount = 50, callbackProcessed;

            function cb(e) {
                if (xhr.aborted || callbackProcessed) {
                    return;
                }
                try {
                    doc = getDoc(io);
                }
                catch (ex) {
                    log('cannot access response document: ', ex);
                    e = SERVER_ABORT;
                }
                if (e === CLIENT_TIMEOUT_ABORT && xhr) {
                    xhr.abort('timeout');
                    return;
                }
                else if (e == SERVER_ABORT && xhr) {
                    xhr.abort('server abort');
                    return;
                }

                if (!doc || doc.location.href == s.iframeSrc) {
                    // response not received yet
                    if (!timedOut)
                        return;
                }
                io.detachEvent ? io.detachEvent('onload', cb) : io.removeEventListener('load', cb, false);

                var status = 'success', errMsg;
                try {
                    if (timedOut) {
                        throw 'timeout';
                    }

                    var isXml = s.dataType == 'xml' || doc.XMLDocument || $.isXMLDoc(doc);
                    log('isXml=' + isXml);
                    if (!isXml && window.opera && (doc.body == null || doc.body.innerHTML == '')) {
                        if (--domCheckCount) {
                            // in some browsers (Opera) the iframe DOM is not always traversable when
                            // the onload callback fires, so we loop a bit to accommodate
                            log('requeing onLoad callback, DOM not available');
                            setTimeout(cb, 250);
                            return;
                        }
                        // let this fall through because server response could be an empty document
                        //log('Could not access iframe DOM after mutiple tries.');
                        //throw 'DOMException: not available';
                    }

                    //log('response detected');
                    var docRoot = doc.body ? doc.body : doc.documentElement;
                    xhr.responseText = docRoot ? docRoot.innerHTML : null;
                    xhr.responseXML = doc.XMLDocument ? doc.XMLDocument : doc;
                    if (isXml)
                        s.dataType = 'xml';
                    xhr.getResponseHeader = function (header) {
                        var headers = { 'content-type': s.dataType };
                        return headers[header];
                    };
                    // support for XHR 'status' & 'statusText' emulation :
                    if (docRoot) {
                        xhr.status = Number(docRoot.getAttribute('status')) || xhr.status;
                        xhr.statusText = docRoot.getAttribute('statusText') || xhr.statusText;
                    }

                    var dt = (s.dataType || '').toLowerCase();
                    var scr = /(json|script|text)/.test(dt);
                    if (scr || s.textarea) {
                        // see if user embedded response in textarea
                        var ta = doc.getElementsByTagName('textarea')[0];
                        if (ta) {
                            xhr.responseText = ta.value;
                            // support for XHR 'status' & 'statusText' emulation :
                            xhr.status = Number(ta.getAttribute('status')) || xhr.status;
                            xhr.statusText = ta.getAttribute('statusText') || xhr.statusText;
                        }
                        else if (scr) {
                            // account for browsers injecting pre around json response
                            var pre = doc.getElementsByTagName('pre')[0];
                            var b = doc.getElementsByTagName('body')[0];
                            if (pre) {
                                xhr.responseText = pre.textContent ? pre.textContent : pre.innerText;
                            }
                            else if (b) {
                                xhr.responseText = b.textContent ? b.textContent : b.innerText;
                            }
                        }
                    }
                    else if (dt == 'xml' && !xhr.responseXML && xhr.responseText != null) {
                        xhr.responseXML = toXml(xhr.responseText);
                    }

                    try {
                        data = httpData(xhr, dt, s);
                    }
                    catch (e) {
                        status = 'parsererror';
                        xhr.error = errMsg = (e || status);
                    }
                }
                catch (e) {
                    log('error caught: ', e);
                    status = 'error';
                    xhr.error = errMsg = (e || status);
                }

                if (xhr.aborted) {
                    log('upload aborted');
                    status = null;
                }

                if (xhr.status) { // we've set xhr.status
                    status = (xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) ? 'success' : 'error';
                }

                // ordering of these callbacks/triggers is odd, but that's how $.ajax does it
                if (status === 'success') {
                    s.success && s.success.call(s.context, data, 'success', xhr);
                    g && $.event.trigger("ajaxSuccess", [xhr, s]);
                }
                else if (status) {
                    if (errMsg == undefined)
                        errMsg = xhr.statusText;
                    s.error && s.error.call(s.context, xhr, status, errMsg);
                    g && $.event.trigger("ajaxError", [xhr, s, errMsg]);
                }

                g && $.event.trigger("ajaxComplete", [xhr, s]);

                if (g && ! --$.active) {
                    $.event.trigger("ajaxStop");
                }

                s.complete && s.complete.call(s.context, xhr, status);

                callbackProcessed = true;
                if (s.timeout)
                    clearTimeout(timeoutHandle);

                // clean up
                setTimeout(function () {
                    if (!s.iframeTarget)
                        $io.remove();
                    xhr.responseXML = null;
                }, 100);
            }

            var toXml = $.parseXML || function (s, doc) { // use parseXML if available (jQuery 1.5+)
                if (window.ActiveXObject) {
                    doc = new ActiveXObject('Microsoft.XMLDOM');
                    doc.async = 'false';
                    doc.loadXML(s);
                }
                else {
                    doc = (new DOMParser()).parseFromString(s, 'text/xml');
                }
                return (doc && doc.documentElement && doc.documentElement.nodeName != 'parsererror') ? doc : null;
            };
            var parseJSON = $.parseJSON || function (s) {
                return window['eval']('(' + s + ')');
            };

            var httpData = function (xhr, type, s) { // mostly lifted from jq1.4.4

                var ct = xhr.getResponseHeader('content-type') || '',
				xml = type === 'xml' || !type && ct.indexOf('xml') >= 0,
				data = xml ? xhr.responseXML : xhr.responseText;

                if (xml && data.documentElement.nodeName === 'parsererror') {
                    $.error && $.error('parsererror');
                }
                if (s && s.dataFilter) {
                    data = s.dataFilter(data, type);
                }
                if (typeof data === 'string') {
                    if (type === 'json' || !type && ct.indexOf('json') >= 0) {
                        data = parseJSON(data);
                    } else if (type === "script" || !type && ct.indexOf("javascript") >= 0) {
                        $.globalEval(data);
                    }
                }
                return data;
            };
        }
    };

    /**
	* ajaxForm() provides a mechanism for fully automating form submission.
	*
	* The advantages of using this method instead of ajaxSubmit() are:
	*
	* 1: This method will include coordinates for <input type="image" /> elements (if the element
	*	is used to submit the form).
	* 2. This method will include the submit element's name/value data (for the element that was
	*	used to submit the form).
	* 3. This method binds the submit() method to the form for you.
	*
	* The options argument for ajaxForm works exactly as it does for ajaxSubmit.  ajaxForm merely
	* passes the options argument along after properly binding events for submit elements and
	* the form itself.
	*/
    $.fn.ajaxForm = function (options) {
        // in jQuery 1.3+ we can fix mistakes with the ready state
        if (this.length === 0) {
            var o = { s: this.selector, c: this.context };
            if (!$.isReady && o.s) {
                log('DOM not ready, queuing ajaxForm');
                $(function () {
                    $(o.s, o.c).ajaxForm(options);
                });
                return this;
            }
            // is your DOM ready?  http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
            log('terminating; zero elements found by selector' + ($.isReady ? '' : ' (DOM not ready)'));
            return this;
        }

        return this.ajaxFormUnbind().bind('submit.form-plugin', function (e) {
            if (!e.isDefaultPrevented()) { // if event has been canceled, don't proceed
                e.preventDefault();
                $(this).ajaxSubmit(options);
            }
        }).bind('click.form-plugin', function (e) {
            var target = e.target;
            var $el = $(target);
            if (!($el.is(":submit,input:image"))) {
                // is this a child element of the submit el?  (ex: a span within a button)
                var t = $el.closest(':submit');
                if (t.length == 0) {
                    return;
                }
                target = t[0];
            }
            var form = this;
            form.clk = target;
            if (target.type == 'image') {
                if (e.offsetX != undefined) {
                    form.clk_x = e.offsetX;
                    form.clk_y = e.offsetY;
                } else if (typeof $.fn.offset == 'function') { // try to use dimensions plugin
                    var offset = $el.offset();
                    form.clk_x = e.pageX - offset.left;
                    form.clk_y = e.pageY - offset.top;
                } else {
                    form.clk_x = e.pageX - target.offsetLeft;
                    form.clk_y = e.pageY - target.offsetTop;
                }
            }
            // clear form vars
            setTimeout(function () { form.clk = form.clk_x = form.clk_y = null; }, 100);
        });
    };

    // ajaxFormUnbind unbinds the event handlers that were bound by ajaxForm
    $.fn.ajaxFormUnbind = function () {
        return this.unbind('submit.form-plugin click.form-plugin');
    };

    /**
	* formToArray() gathers form element data into an array of objects that can
	* be passed to any of the following ajax functions: $.get, $.post, or load.
	* Each object in the array has both a 'name' and 'value' property.  An example of
	* an array for a simple login form might be:
	*
	* [ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
	*
	* It is this array that is passed to pre-submit callback functions provided to the
	* ajaxSubmit() and ajaxForm() methods.
	*/
    $.fn.formToArray = function (semantic) {
        var a = [];
        if (this.length === 0) {
            return a;
        }

        var form = this[0];
        var els = semantic ? form.getElementsByTagName('*') : form.elements;
        if (!els) {
            return a;
        }

        var i, j, n, v, el, max, jmax;
        for (i = 0, max = els.length; i < max; i++) {
            el = els[i];
            n = el.name;
            if (!n) {
                continue;
            }

            if (semantic && form.clk && el.type == "image") {
                // handle image inputs on the fly when semantic == true
                if (!el.disabled && form.clk == el) {
                    a.push({ name: n, value: $(el).val(), type: el.type });
                    a.push({ name: n + '.x', value: form.clk_x }, { name: n + '.y', value: form.clk_y });
                }
                continue;
            }

            v = $.fieldValue(el, true);
            if (v && v.constructor == Array) {
                for (j = 0, jmax = v.length; j < jmax; j++) {
                    a.push({ name: n, value: v[j] });
                }
            }
            else if (v !== null && typeof v != 'undefined') {
                a.push({ name: n, value: v, type: el.type });
            }
        }

        if (!semantic && form.clk) {
            // input type=='image' are not found in elements array! handle it here
            var $input = $(form.clk), input = $input[0];
            n = input.name;
            if (n && !input.disabled && input.type == 'image') {
                a.push({ name: n, value: $input.val() });
                a.push({ name: n + '.x', value: form.clk_x }, { name: n + '.y', value: form.clk_y });
            }
        }
        return a;
    };

    /**
	* Serializes form data into a 'submittable' string. This method will return a string
	* in the format: name1=value1&amp;name2=value2
	*/
    $.fn.formSerialize = function (semantic) {
        //hand off to jQuery.param for proper encoding
        return $.param(this.formToArray(semantic));
    };

    /**
	* Serializes all field elements in the jQuery object into a query string.
	* This method will return a string in the format: name1=value1&amp;name2=value2
	*/
    $.fn.fieldSerialize = function (successful) {
        var a = [];
        this.each(function () {
            var n = this.name;
            if (!n) {
                return;
            }
            var v = $.fieldValue(this, successful);
            if (v && v.constructor == Array) {
                for (var i = 0, max = v.length; i < max; i++) {
                    a.push({ name: n, value: v[i] });
                }
            }
            else if (v !== null && typeof v != 'undefined') {
                a.push({ name: this.name, value: v });
            }
        });
        //hand off to jQuery.param for proper encoding
        return $.param(a);
    };

    /**
	* Returns the value(s) of the element in the matched set.  For example, consider the following form:
	*
	*  <form><fieldset>
	*	  <input name="A" type="text" />
	*	  <input name="A" type="text" />
	*	  <input name="B" type="checkbox" value="B1" />
	*	  <input name="B" type="checkbox" value="B2"/>
	*	  <input name="C" type="radio" value="C1" />
	*	  <input name="C" type="radio" value="C2" />
	*  </fieldset></form>
	*
	*  var v = $(':text').fieldValue();
	*  // if no values are entered into the text inputs
	*  v == ['','']
	*  // if values entered into the text inputs are 'foo' and 'bar'
	*  v == ['foo','bar']
	*
	*  var v = $(':checkbox').fieldValue();
	*  // if neither checkbox is checked
	*  v === undefined
	*  // if both checkboxes are checked
	*  v == ['B1', 'B2']
	*
	*  var v = $(':radio').fieldValue();
	*  // if neither radio is checked
	*  v === undefined
	*  // if first radio is checked
	*  v == ['C1']
	*
	* The successful argument controls whether or not the field element must be 'successful'
	* (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
	* The default value of the successful argument is true.  If this value is false the value(s)
	* for each element is returned.
	*
	* Note: This method *always* returns an array.  If no valid value can be determined the
	*	array will be empty, otherwise it will contain one or more values.
	*/
    $.fn.fieldValue = function (successful) {
        for (var val = [], i = 0, max = this.length; i < max; i++) {
            var el = this[i];
            var v = $.fieldValue(el, successful);
            if (v === null || typeof v == 'undefined' || (v.constructor == Array && !v.length)) {
                continue;
            }
            v.constructor == Array ? $.merge(val, v) : val.push(v);
        }
        return val;
    };

    /**
	* Returns the value of the field element.
	*/
    $.fieldValue = function (el, successful) {
        var n = el.name, t = el.type, tag = el.tagName.toLowerCase();
        if (successful === undefined) {
            successful = true;
        }

        if (successful && (!n || el.disabled || t == 'reset' || t == 'button' ||
		(t == 'checkbox' || t == 'radio') && !el.checked ||
		(t == 'submit' || t == 'image') && el.form && el.form.clk != el ||
		tag == 'select' && el.selectedIndex == -1)) {
            return null;
        }

        if (tag == 'select') {
            var index = el.selectedIndex;
            if (index < 0) {
                return null;
            }
            var a = [], ops = el.options;
            var one = (t == 'select-one');
            var max = (one ? index + 1 : ops.length);
            for (var i = (one ? index : 0) ; i < max; i++) {
                var op = ops[i];
                if (op.selected) {
                    var v = op.value;
                    if (!v) { // extra pain for IE...
                        v = (op.attributes && op.attributes['value'] && !(op.attributes['value'].specified)) ? op.text : op.value;
                    }
                    if (one) {
                        return v;
                    }
                    a.push(v);
                }
            }
            return a;
        }
        return $(el).val();
    };

    /**
	* Clears the form data.  Takes the following actions on the form's input fields:
	*  - input text fields will have their 'value' property set to the empty string
	*  - select elements will have their 'selectedIndex' property set to -1
	*  - checkbox and radio inputs will have their 'checked' property set to false
	*  - inputs of type submit, button, reset, and hidden will *not* be effected
	*  - button elements will *not* be effected
	*/
    $.fn.clearForm = function (includeHidden) {
        return this.each(function () {
            $('input,select,textarea', this).clearFields(includeHidden);
        });
    };

    /**
	* Clears the selected form elements.
	*/
    $.fn.clearFields = $.fn.clearInputs = function (includeHidden) {
        var re = /^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i; // 'hidden' is not in this list
        return this.each(function () {
            var t = this.type, tag = this.tagName.toLowerCase();
            if (re.test(t) || tag == 'textarea' || (includeHidden && /hidden/.test(t))) {
                this.value = '';
            }
            else if (t == 'checkbox' || t == 'radio') {
                this.checked = false;
            }
            else if (tag == 'select') {
                this.selectedIndex = -1;
            }
        });
    };

    /**
	* Resets the form data.  Causes all form elements to be reset to their original value.
	*/
    $.fn.resetForm = function () {
        return this.each(function () {
            // guard against an input with the name of 'reset'
            // note that IE reports the reset function as an 'object'
            if (typeof this.reset == 'function' || (typeof this.reset == 'object' && !this.reset.nodeType)) {
                this.reset();
            }
        });
    };

    /**
	* Enables or disables any matching elements.
	*/
    $.fn.enable = function (b) {
        if (b === undefined) {
            b = true;
        }
        return this.each(function () {
            this.disabled = !b;
        });
    };

    /**
	* Checks/unchecks any matching checkboxes or radio buttons and
	* selects/deselects and matching option elements.
	*/
    $.fn.selected = function (select) {
        if (select === undefined) {
            select = true;
        }
        return this.each(function () {
            var t = this.type;
            if (t == 'checkbox' || t == 'radio') {
                this.checked = select;
            }
            else if (this.tagName.toLowerCase() == 'option') {
                var $sel = $(this).parent('select');
                if (select && $sel[0] && $sel[0].type == 'select-one') {
                    // deselect all other options
                    $sel.find('option').selected(false);
                }
                this.selected = select;
            }
        });
    };

    // expose debug var
    $.fn.ajaxSubmit.debug = false;

    // helper fn for console logging
    function log() {
        if (!$.fn.ajaxSubmit.debug)
            return;
        var msg = '[jquery.form] ' + Array.prototype.join.call(arguments, '');
        if (window.console && window.console.log) {
            window.console.log(msg);
        }
        else if (window.opera && window.opera.postError) {
            window.opera.postError(msg);
        }
    };

})(jQuery);

(function ($) {
    jQuery.fn.maxlength = function (options) {

        var settings = jQuery.extend({
            onLimit: function () { },
            onEdit: function () { }
        }, options);

        // Event handler to limit the textarea
        var onEdit = function () {
            var textarea = jQuery(this);
            var maxlength = parseInt(textarea.data("maxlength"));

            var text = textarea.val();
            var len = 0;
            var val = '';
            var char = '';

            for (var i = 0; i < text.length; i++) {
                if (Math.ceil(len) >= maxlength) {
                    textarea.val(val).focus();

                    // Call the onlimit handler within the scope of the textarea
                    jQuery.proxy(settings.onLimit, this)();

                    break;
                }

                char = text.charCodeAt(i);
                val += text.substr(i, 1);

                if (!(char > 255)) {
                    len = len + .5;
                } else {
                    len = len + 1;
                }
            }

            // Call the onEdit handler within the scope of the textarea
            jQuery.proxy(settings.onEdit, this)(maxlength - Math.ceil(len));
        }

        this.each(onEdit);

        var obj_interval;

        if (jQuery.browser.msie && jQuery.browser.version < 10) {
            this.bind('focus', function () {
                var tb = $(this);
                obj_interval = setInterval(function () { tb.trigger('change'); }, 50);
            }).bind('blur', function () {
                if (obj_interval != null)
                    clearInterval(obj_interval);
            });
        }

        return this.keyup(onEdit)
                    .keydown(onEdit)
                    .focus(onEdit)
                    .bind('input paste change', onEdit);
    };
})(jQuery);

(function ($) {
    $.fn.gform = function (opts) {
        opts = $.extend(true, {}, $.fn.gform.defaults, opts);

        $(this).each(function (i, v) {
            var $this = $(v);

            var isEmbed = ($this.data('embed') == 'True');

            var bind = function () {
                var f = $this;
                $('select', f).addClass('ui-widget-content');
                $(':text,:password,textarea', f)
                    .addClass('ui-widget-content ui-corner-all')
                    .bind('focus', function () { $(this).addClass('focus'); })
                    .bind('blur', function () { $(this).removeClass('focus'); })
                    .each(function () {
                        if (!$(this).data('clearable')) return true;
                        $(this).bind('focus', function () { $(this).next().hide(); })
                            .bind('blur', function () { if ($(this).val()) $(this).next().show(); })
                            .after('<a title="清空" href="#" class="close" style="display:none;">×</a>').parent().find('.close')
                            .bind('click', function () {
                                var ele = $(this).prev();
                                if (ele[0].nodeName == 'INPUT')
                                    ele.val('');
                                else
                                    ele.text('');

                                if (ele.data('clearcallback')) {
                                    var func = eval(ele.data('clearcallback'));
                                    if (func && jQuery.isFunction(func))
                                        func.apply(null, [ele]);
                                }

                                $(this).hide();

                                return false;
                            });

                        $(this).trigger('blur');
                    });

                // default value
                $('select[selected]', f).each(function (i, v) {
                    var val = v.getAttribute('selected');
                    $.fn.gform.set_select_val($(v), $(v).attr('multiple') == 'multiple' ? val.split(',') : val, true);
                });

                window.setTimeout(function () {
                    $(':checkbox[selected],:radio[selected]', f).each(function (i, v) {
                        var $o = $(v);
                        $o.prop('checked', v.getAttribute('selected') == $o.val());
                    });

                    // focus first input
                    if (!opts.bindOnly && opts.focus_first_input) {
                        var inputs = $(':text:enabled:visible,textarea:enabled:visible', f).filter(function () {
                            return !$(this).attr('readonly') && $(this).parent(':hidden').size() == 0;
                        });
                        if (inputs.length > 0) {
                            inputs[0].focus();
                        }
                    }
                }, 100);

                if (opts.enter_to_submit) {
                    $('input:enabled', f).bind('keypress', function (e) {
                        if (e.keyCode == 13) f.submit();
                    });
                }

                if (opts.autoAddRedStar) {
                    var inputs = $('input:enabled,textarea:enabled', f).filter(function () {
                        return $(this).attr('minlength') !== undefined && parseInt($(this).attr('minlength'), 10) > 0;
                    });
                    $.each(inputs, function (i, v) {
                        var id = $(v).parents('label:first').find('.g1').prepend('<em>*</em>');
                    });
                }

                $(':text:enabled:visible,:password:enabled:visible,textarea:enabled:visible', f).filter(function () {
                    return !$(this).attr('readonly') && $(this).parent(':hidden').size() == 0;
                }).placeholder();

                $(':text:enabled,:password:enabled,textarea:enabled', f).filter(function () {
                    return !$(this).attr('readonly') && $(this).data('maxlength');
                }).maxlength();
            };

            bind();

            if (opts.bindOnly) return;

            var beforeSubmit = function (formData, jqForm, options) {
                if ($.fn.gform.working)
                    return false;

                var valid = true;

                try {
                    // clean up
                    var elems = $(':input', $this).removeClass('ui-state-error');
                    $.each(elems, function (i, v) {
                        var ele = $(v);

                        if (ele.parent(':hidden').size() > 0)
                            return true;

                        valid = $.fn.gform.checkLength(ele);
                        if (valid) valid = $.fn.gform.checkValue(ele);
                        if (valid) valid = $.fn.gform.checkClasses(ele);
                        if (valid) valid = $.fn.gform.checkRegexp(ele);
                        if (valid) valid = $.fn.gform.checkFunction(ele);

                        if (!valid)
                            return false;
                    });

                    if (valid && opts.submitFunc && $.isFunction(opts.submitFunc)) {
                        var qs = $.param(formData);
                        opts.submitFunc.apply(jqForm, [qs]);
                        return false;
                    }

                    return valid;
                }
                catch (e) {
                    $.fn.gform.working = false;
                    alert(e.message || '出错了!');
                    return false;
                };
            };

            var onSuccess = function (data, status) {
                $.fn.gform.working = false;

                var r;
                try {
                    r = jQuery.parseJSON(data);
                } catch (e) {
                    r = data;
                }
                if (r != null && r.__AjaxException) {
                    r = handleException(r);
                }
                if (r != undefined && opts.onSuccess && $.isFunction(opts.onSuccess)) {
                    opts.onSuccess.apply($this, [r, status]);
                }
            };

            if (opts.ajax) {
                var url = opts.url;
                if (!url)
                    url = $this.attr('action') || window.location.toString();

                var ix = url.indexOf('#');
                if (url && ix != -1) {

                    if (isEmbed)
                        url = url.substr(ix + 1);
                    else
                        url = url.substr(0, ix);
                }
                if (opts.submitFunc == null && !url) {
                    alert('表单提交的url不能为空'); return;
                }
                $this.ajaxForm({
                    beforeSubmit: beforeSubmit,
                    success: onSuccess,
                    url: url
                });
            } else {
                $this.submit(beforeSubmit);
            }
        });

        return $(this);
    };

    $.fn.gform.working = false;

    $.fn.gform.defaults = {
        bindOnly: false,
        ajax: true,
        url: '',
        onSuccess: null,
        submitFunc: null,
        autoAddRedStar: true,
        focus_first_input: false,
        enter_to_submit: false
    };

    $.fn.gform.updateTips = function (t) {
        if (t) window.alert(t);
    };

    $.fn.gform._getTitle = function (ele) {
        var title = ele.attr('key');
        if (!title)
            title = ele.parents('label:first').find('.g1').text();
        if (!title)
            title = ele.prev().text();
        return $.trim(title).replace(':', '').replace('：', '').replace('*', '');
    };

    $.fn.gform.checkLength = function (ele) {
        var minlen = parseInt(ele.attr('minlength'), 10);
        if (!isNaN(minlen) && minlen > -1) {
            var value = $.trim(ele.val().toString());
            if (value == '' || ele.val().toString() === ele.attr('title')) {
                ele.addClass('ui-state-error').focus();
                $.fn.gform.updateTips($.fn.gform._getTitle(ele) + "不能为空!");
                return false;
            }
            else if (value.length < minlen) {
                ele.addClass('ui-state-error').focus();
                $.fn.gform.updateTips($.fn.gform._getTitle(ele) + "的长度必须大于或等于" + minlen);
                return false;
            }
        }

        var maxlen = parseInt(ele.attr('maxlength'), 10);
        if (!isNaN(maxlen) && maxlen > -1) {
            var value = $.trim(ele.val().toString());
            if (value.length > maxlen) {
                ele.addClass('ui-state-error').focus();
                $.fn.gform.updateTips($.fn.gform._getTitle(ele) + "的长度不能超过" + maxlen);
                return false;
            }
        }

        return true;
    };

    $.fn.gform.checkValue = function (ele) {
        if (ele.val() == null || $.trim(ele.val().toString()) == '') return true;
        var min = parseFloat(ele.attr('min'));
        var max = parseFloat(ele.attr('max'));
        if (!isNaN(min) || !isNaN(max)) {
            var fv = parseFloat(ele.val().toString());
            if (isNaN(fv)) {
                ele.addClass('ui-state-error').focus();
                $.fn.gform.updateTips($.fn.gform._getTitle(ele) + '必须是一个数字！');
                return false;
            }
            else {
                if (fv < min) {
                    ele.addClass('ui-state-error').focus();
                    $.fn.gform.updateTips($.fn.gform._getTitle(ele) + '必须大于等于' + min + '！');
                    return false;
                } else if (fv > max) {
                    ele.addClass('ui-state-error').focus();
                    $.fn.gform.updateTips($.fn.gform._getTitle(ele) + '必须小于等于' + max + '！');
                    return false;
                }
            }
            return true;
        }

        return true;
    };

    $.fn.gform.checkRegexp = function (o) {
        if (o.val() == null || $.trim(o.val().toString()) == '') return true;
        var reg = o.attr('reg');
        if (!reg)
            return true;
        reg = eval(reg);
        if (!(reg.test($.trim(o.val().toString())))) {
            o.addClass('ui-state-error').focus();
            $.fn.gform.updateTips($.fn.gform._getTitle(o) + '的格式不正确!');
            return false;
        }
        return true;
    };

    $.fn.gform.checkClasses = function (o) {
        if (o.val() == null || $.trim(o.val().toString()) == '') return true;
        var reg = null;
        var cls = o.attr('class');
        if (!cls) return true;
        $.each(cls.split(' '), function (i, v) {
            if (!v) return true;
            var r = $.fn.gform.commonregs[v];
            if (r == undefined) return true;
            reg = r;
            return false;
        });
        if (!reg) return true;
        if (!(reg.test($.trim(o.val().toString())))) {
            o.addClass('ui-state-error').focus();
            $.fn.gform.updateTips($.fn.gform._getTitle(o) + '的格式不正确!');
            return false;
        }
        return true;
    };

    $.fn.gform.checkFunction = function (ele) {
        var func = ele.attr('func');
        if (!func)
            return true;
        func = eval(func);
        if ($.isFunction(func)) {
            var ret = func.apply(ele, [$.trim(ele.val().toString())]);
            if (!ret || !ret.ok) {
                return false;
            }
        }
        return true;
    };

    $.fn.gform.set_select_val = function (select, value, triggerChange) {
        if (!value) {
            value = select.find('option:first').attr('value');
        }
        try {
            select.val(value);

            if (triggerChange)
                select.trigger('change');
        }
        catch (e) {
            setTimeout(function () {
                select.val(value);

                if (triggerChange)
                    select.trigger('change');
            }, 1);
        }
    };

    $.fn.gform.commonregs = {
        ip: /^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/,
        url: /^(https?|ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(\#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i,
        email: /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(\.[a-zA-Z0-9_-])+/,
        date: /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-))$/,
        num: /^[-]?\d+(\.\d+)?$/,
        mobile: /^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/,
        zipcode: /^[a-zA-Z0-9 ]{3,12}$/,
        phone: /^[+]{0,1}(\d){1,3}[ ]?([-]?((\d)|[ ]){1,12})+$/,
        password: /^(\w){6,20}$/,
        simpletext: /^[a-zA-Z][a-zA-Z0-9_]*$/,
        text: /^[^<^>^&]*$/
    };

    $.fn.resetform = function () {
        $(':input', this).removeClass('ui-state-error');
        this[0].reset();
    };

})(jQuery);

/*! http://mths.be/placeholder v2.0.7 by @mathias */
; (function (window, document, $) {

    var isInputSupported = 'placeholder' in document.createElement('input'),
	    isTextareaSupported = 'placeholder' in document.createElement('textarea'),
	    prototype = $.fn,
	    valHooks = $.valHooks,
	    hooks,
	    placeholder;

    if (isInputSupported && isTextareaSupported) {

        placeholder = prototype.placeholder = function () {
            return this;
        };

        placeholder.input = placeholder.textarea = true;

    } else {

        placeholder = prototype.placeholder = function () {
            var $this = this;
            $this
				.filter((isInputSupported ? 'textarea' : ':input') + '[placeholder]')
				.not('.placeholder')
				.bind({
				    'focus.placeholder': clearPlaceholder,
				    'blur.placeholder': setPlaceholder
				})
				.data('placeholder-enabled', true)
				.trigger('blur.placeholder');
            return $this;
        };

        placeholder.input = isInputSupported;
        placeholder.textarea = isTextareaSupported;

        hooks = {
            'get': function (element) {
                var $element = $(element);
                return $element.data('placeholder-enabled') && $element.hasClass('placeholder') ? '' : element.value;
            },
            'set': function (element, value) {
                var $element = $(element);
                if (!$element.data('placeholder-enabled')) {
                    return element.value = value;
                }
                if (value == '') {
                    element.value = value;
                    // Issue #56: Setting the placeholder causes problems if the element continues to have focus.
                    if (element != document.activeElement) {
                        // We can’t use `triggerHandler` here because of dummy text/password inputs :(
                        setPlaceholder.call(element);
                    }
                } else if ($element.hasClass('placeholder')) {
                    clearPlaceholder.call(element, true, value) || (element.value = value);
                } else {
                    element.value = value;
                }
                // `set` can not return `undefined`; see http://jsapi.info/jquery/1.7.1/val#L2363
                return $element;
            }
        };

        isInputSupported || (valHooks.input = hooks);
        isTextareaSupported || (valHooks.textarea = hooks);

        $(function () {
            // Look for forms
            $(document).delegate('form', 'submit.placeholder', function () {
                // Clear the placeholder values so they don’t get submitted
                var $inputs = $('.placeholder', this).each(clearPlaceholder);
                setTimeout(function () {
                    $inputs.each(setPlaceholder);
                }, 10);
            });
        });

        // Clear placeholder values upon page reload
        $(window).bind('beforeunload.placeholder', function () {
            $('.placeholder').each(function () {
                this.value = '';
            });
        });

    }

    function args(elem) {
        // Return an object of element attributes
        var newAttrs = {},
		    rinlinejQuery = /^jQuery\d+$/;
        $.each(elem.attributes, function (i, attr) {
            if (attr.specified && !rinlinejQuery.test(attr.name)) {
                newAttrs[attr.name] = attr.value;
            }
        });
        return newAttrs;
    }

    function clearPlaceholder(event, value) {
        var input = this,
		    $input = $(input);
        if (input.value == $input.attr('placeholder') && $input.hasClass('placeholder')) {
            if ($input.data('placeholder-password')) {
                $input = $input.hide().next().show().attr('id', $input.removeAttr('id').data('placeholder-id'));
                // If `clearPlaceholder` was called from `$.valHooks.input.set`
                if (event === true) {
                    return $input[0].value = value;
                }
                $input.focus();
            } else {
                input.value = '';
                $input.removeClass('placeholder');
                input == document.activeElement && input.select();
            }
        }
    }

    function setPlaceholder() {
        var $replacement,
		    input = this,
		    $input = $(input),
		    $origInput = $input,
		    id = this.id;
        if (input.value == '') {
            if (input.type == 'password') {
                if (!$input.data('placeholder-textinput')) {
                    try {
                        $replacement = $input.clone().attr({ 'type': 'text' });
                    } catch (e) {
                        $replacement = $('<input>').attr($.extend(args(this), { 'type': 'text' }));
                    }
                    $replacement
						.removeAttr('name')
						.data({
						    'placeholder-password': true,
						    'placeholder-id': id
						})
						.bind('focus.placeholder', clearPlaceholder);
                    $input
						.data({
						    'placeholder-textinput': $replacement,
						    'placeholder-id': id
						})
						.before($replacement);
                }
                $input = $input.removeAttr('id').hide().prev().attr('id', id).show();
                // Note: `$input[0] != input` now!
            }
            $input.addClass('placeholder');
            $input[0].value = $input.attr('placeholder');
        } else {
            $input.removeClass('placeholder');
        }
    }

}(this, document, jQuery));

jQuery(document).ajaxStart(function () { jQuery('.gloading').show(); $.fn.gform.working = true; }).ajaxStop(function () { jQuery('.gloading').hide(); $.fn.gform.working = false; });

(function ($) {
    var settings;

    $.fn.gtable = function (opts) {
        var $this = $(this);
        $('>tbody tr', this).filter(':odd').addClass('odd');
        $('>tbody tr', this).hover(function () { $(this).addClass('hover'); }, function () { $(this).removeClass('hover'); });

        settings = $.extend(true, {}, $.fn.gtable.defaults, opts);

        var headerCheckbox;
        var columnCheckboxes;

        if (isNaN(settings.column)) {
            var sel = "thead tr th:" + settings.column + "-child input:checkbox,tfoot tr th:" + settings.column + "-child input:checkbox";
            headerCheckbox = $(sel, this);
            columnCheckboxes = $("tbody tr td:" + settings.column + "-child input:checkbox", this);
        }
        else {
            var sel = "thead tr th:nth-child(" + settings.column + ") input:checkbox,tfoot tr th:nth-child(" + settings.column + ") input:checkbox";
            headerCheckbox = $(sel, this);
            columnCheckboxes = $("tbody tr td:nth-child(" + settings.column + ") input:checkbox", this);
        }

        headerCheckbox.attr("title", settings.selectTip);

        headerCheckbox.click(function () {
            var checkedStatus = this.checked;

            columnCheckboxes.each(function () {
                this.checked = checkedStatus;
                if (this.checked)
                    $(this).parents('tr:first').addClass('selected');
                else
                    $(this).parents('tr:first').removeClass('selected');
            });

            if (checkedStatus == true) {
                $(this).attr("title", settings.unselectTip);
            }
            else {
                $(this).attr("title", settings.selectTip);
            }

            $this.trigger('gtable.row_selected', [$this.getSelectedRowIds()]);
        });

        columnCheckboxes.change(function () {
            var checked = columnCheckboxes.filter(':checked');
            if (checked.length == columnCheckboxes.length) {
                headerCheckbox.attr('checked', true).attr('title', settings.unselectTip);
            } else {
                headerCheckbox.attr('checked', false).attr('title', settings.selectTip);
            }
        });

        if (headerCheckbox.attr('checked'))
            headerCheckbox.trigger('click');

        // click to select
        if (settings.clickToSelect) {
            $('tbody tr', this).filter('td:first-child :has(:checkbox:checked)').addClass('selected').end().click(function (event) {
                if (event.target.type == 'checkbox')
                    $(this).toggleClass('selected');
                else if (event.target.tagName == 'TD') {
                    $(':checkbox:first', this).attr('checked', function () {
                        return !this.checked;
                    }).trigger('change');
                    $(this).toggleClass('selected');
                }

                $this.trigger('gtable.row_selected', [$this.getSelectedRowIds()]);
            });
        }
        else {
            columnCheckboxes.click(function () {
                if (this.checked)
                    $(this).parents('tr:first').addClass('selected');
                else
                    $(this).parents('tr:first').removeClass('selected');

                $this.trigger('gtable.row_selected', [$this.getSelectedRowIds()]);
            });
        }

        // sort
        var init_sort = function () {
            if (settings.sortablecolumns && typeof settings.sortablecolumns == 'string') {
                var columns = settings.sortablecolumns.split(',');

                jQuery.each(columns, function (i, v) {
                    var id = jQuery.trim(v);
                    if (id) $("thead tr [id='" + id + "']", $this).addClass('sortable');
                });
            }

            if (settings.sort == '') {
                if ($this.parents('form:first').length == 1)
                    settings.sort = "ajax";
                else
                    settings.sort = "default";
            }

            if (settings.sort == 'default' && !$.query) return;

            var sort = '';
            var sort_column = '';

            $('thead .sortable', $this).each(function () {
                var th = $(this),
                thIndex = th.index(),
                inverse = true;

                th.html('<div>' + th.html() + '<span title="排序"></span></div>');

                // 修复宽度缩小问题
                if (th.attr('width'))
                    th.find('div').css('width', th.attr('width'));

                var compare = th.attr('data_type') || 'string';

                $(this).find('> div').click(function () {
                    if (settings.sort == 'inline') {
                        $this.last().find('td').filter(function () {
                            return $(this).index() === thIndex;
                        }).sortElements(function (a, b) {
                            var c;
                            if ($(a).attr('data_sort')) {
                                var d_a = $(a).attr('data_sort'), d_b = $(b).attr('data_sort');
                                if (compare == 'date')
                                    c = new Date(d_a) > new Date(d_b);
                                else if (compare == 'num')
                                    c = parseFloat(d_a) > parseFloat(d_b);
                                else
                                    c = d_a > d_b;
                            }
                            else
                                c = $.text([a]) > $.text([b]);
                            return c ?
                                inverse ? -1 : 1
                                : inverse ? 1 : -1;
                        }, function () {
                            return this.parentNode;
                        });

                        inverse = !inverse;

                        $('thead .sortable span', $this).removeClass('desc').removeClass('asc');

                        $this.find('span').addClass(inverse ? 'asc' : 'desc');
                    }
                    else if (settings.sort == 'ajax') {
                        var column = th.attr('id');
                        if ((sort_column == column && !sort.startWith('-')) || sort_column != column)
                            column = '-' + column;

                        var form = $this.parents('form:first');
                        if ($('input[name=sort]', form).length == 0)
                            form.append('<input type="hidden" name="sort"/>');

                        $('input[name=sort]', form).val(column);
                        $('input[name=page]', form).val(1);

                        form.submit();
                    }
                    else {
                        var column = th.attr('id');
                        if ((sort_column == column && !sort.startWith('-')) || sort_column != column)
                            column = '-' + column;
                        var path = window.location.pathname;
                        var index = path.indexOf('.');
                        if (index != -1)
                            path = '1' + path.substr(index);

                        window.location = path + jQuery.query.set('sort', column);
                    }
                });
            });

            if (settings.sort == 'ajax') {
                var form = $this.parents('form:first');
                sort = $('input[name=sort]', form).val();
            } else if ($.query)
                sort = jQuery.query.get('sort');

            if (sort && typeof sort == 'string') {
                var asc = !sort.startWith('-');
                if (!asc)
                    sort_column = sort.substr(1);
                else
                    sort_column = sort;
                if (sort_column) $("thead [id='" + sort_column + "'] span", $this).addClass(asc ? 'asc' : 'desc');
            }
        };

        init_sort();

        // column resize
        //get number of columns 
        if (settings.resizable) {
            var wrap = $('<div style="width: auto;" ></div>');

            $this.addClass('resizable').wrap(wrap);

            $('<div class="autodiv"></div>').insertBefore($this);

            var numberOfColumns = $this.first().find('thead TR TH.resizable').size();
            if (numberOfColumns > 0) {

                var resetTableSizes = function (change, columnIndex) {
                    //calculate new width       
                    var myWidth = $this.first().find(' TR TH.resizable').get(columnIndex).offsetWidth;
                    var newWidth = (myWidth + change);

                    if (newWidth <= 0) {
                        resetSliderPositions();
                        return false;
                    }

                    // resize th
                    var th = $this.first().find('thead TR TH.resizable').eq(columnIndex);
                    th.css('width', newWidth);

                    var ix = $this.first().find('thead TR TH').index(th);

                    $this.css('width', $this.outerWidth() + change).find(' TR').each(function () {
                        $(this).find('TD').eq(ix).css('width', newWidth);
                    });
                    resetSliderPositions();
                };

                var resetSliderPositions = function () {
                    var h = $this.first().height();
                    //put all sliders on the correct position
                    $this.first().find('thead TR TH.resizable').each(function (index) {
                        var th = $(this);
                        var newSliderPosition = th.offset().left + th.outerWidth();
                        $('.draghandle:eq(' + index + ')').css({ left: newSliderPosition, height: h, top: th.offset().top });
                    });
                }

                for (var i = 0; i < numberOfColumns; i++) {
                    var html = $('<div class="draghandle"></div>').data('ix', i);

                    html.draggable({
                        axis: "x",
                        start: function () {
                            $(this).toggleClass("dragged");
                            //set the height of the draghandle to the current height of the table, to get the vertical ruler
                            $(this).css({ height: $this.last().height() + 'px' });
                        },
                        stop: function (event, ui) {
                            $(this).toggleClass("dragged");
                            var oldPos = ui.originalPosition.left;
                            var newPos = ui.position.left;
                            var index = $(this).data("ix");
                            resetTableSizes(newPos - oldPos, index);
                        }
                    });

                    $('body').append(html);
                };

                resetSliderPositions();

                $(window).bind('resize', function () {
                    resetSliderPositions();
                });
            }
        }
        return $this;
    };

    $.fn.gtable.defaults = {
        column: 'first',
        selectTip: '全选',
        unselectTip: '全不选',
        clickToSelect: true,
        sortablecolumns: null,
        sort: '',
        resizable: false
    };

    $.fn.getSelectedRowIds = function () {
        var ids = [];

        $.each($("tbody tr td:first-child :checkbox[checked]", this), function (i, v) {
            ids.push(encodeURIComponent($(this).parents('tr:first').attr('id')));
        });
        return ids;
    };

    $.fn.removeRow = function (rowId) {
        var t = this;
        var redirect = function (len) {
            var form = t.parents('form:first');
            if (form.length == 1) {
                var cp = $('input[name=page]', form);
                if (cp.length == 0)
                    form.append('<input type="hidden" name="page"/>');

                var page = parseInt($.trim($('.pagination .current', form).text()), 10) || 1;
                if ($('tbody tr', t).length == len) {
                    page = Math.max(1, page - 1);
                }

                $('input[name=page]', form).val(page);

                jQuery.fn.gform.working = false;
                form.submit();
            }
            else {
                if ($('tbody tr', t).length == len) {
                    $.paging.goto('prev');
                }
                else {
                    window.location.reload();
                }
            }
        };

        if (!rowId || rowId.constructor.toString().indexOf("Array") == -1)
            redirect(1);
        else {
            redirect(rowId.length);
        }
    };
})(jQuery);

String.prototype.startWith = function (str) {
    if (str == null || str == "" || this.length == 0 || str.length > this.length)
        return false;
    if (this.substr(0, str.length) == str)
        return true;
    else
        return false;
    return true;
};

jQuery.fn.sortElements = (function () {

    var sort = [].sort;

    return function (comparator, getSortable) {

        getSortable = getSortable || function () { return this; };

        var placements = this.map(function () {

            var sortElement = getSortable.call(this),
                parentNode = sortElement.parentNode,

            // Since the element itself will change position, we have
            // to have some way of storing it's original position in
            // the DOM. The easiest way is to have a 'flag' node:
                nextSibling = parentNode.insertBefore(
                    document.createTextNode(''),
                    sortElement.nextSibling
                );

            return function () {

                if (parentNode === this) {
                    throw new Error(
                        "You can't sort elements if any one is a descendant of another."
                    );
                }

                // Insert before flag:
                parentNode.insertBefore(this, nextSibling);
                // Remove flag:
                parentNode.removeChild(nextSibling);

            };

        });

        return sort.call(this, comparator).each(function (i) {
            placements[i].call(getSortable.call(this));
        });

    };

})();

/*
分页js
1，支持键盘的分页
2，支持跳转到指定页码的api
*/
(function ($) {

    $.paging = {
        keyword: function () {
            var focusInInput = false;

            var navigation = function (event) {
                if (window.event) event = window.event;

                if (!focusInInput) {
                    switch (event.keyCode ? event.keyCode : event.which ? event.which : null) {
                        case 0x25:
                            $.paging.goto('prev');
                            break;
                        case 0x27:
                            $.paging.goto('next');
                            break;
                    }
                }
            };

            $(':text,textarea,:file').live('focus', function () { focusInInput = true; }).live('blur', function () { focusInInput = false; });

            document.onkeydown = navigation;
        },
        goto: function (p) {
            var path = window.location.pathname;
            var file = '';
            var pre = '';
            var ix_splash = path.lastIndexOf('/');
            if (ix_splash == -1)
                file = path;
            else {
                pre = path.substr(0, ix_splash + 1);
                file = path.substr(ix_splash + 1);
            }

            var page = '';
            var extension = '';
            var ix_dot = file.lastIndexOf('.');
            if (ix_dot == -1)
                page = file;
            else {
                page = file.substr(0, ix_dot);
                extension = file.substr(ix_dot);
            }

            var pi;
            if (!isNaN(parseInt(p, 10)))
                pi = parseInt(p, 10);
            else if (p == 'prev')
                pi = Math.max(1, parseInt(page) - 1);
            else if (p == 'next')
                pi = Math.min(1, parseInt(page) + 1);

            window.location = pre + pi + extension + window.location.search;
        },
        ajax: function (selector) {
            $(selector).each(function (i, v) {
                var $this = $(v);
                if (!$this.hasClass('ajax')) {
                    $this.addClass('ajax');

                    var form = $this.parents('form:first');
                    if (form.length == 0) return false;

                    $('.pagination a', form).click(function () {
                        var p = 1;
                        var ts = $(this);
                        var _form = ts.parents('form:first');

                        if (ts.hasClass('next'))
                            p = parseInt(ts.parents('.pagination:first').find('.current:last').text()) + 1;
                        else if (ts.hasClass('prev'))
                            p = parseInt(ts.parents('.pagination:first').find('.current:first').text()) - 1;
                        else if (ts.hasClass('first'))
                            p = 1;
                        else if (ts.hasClass('last'))
                            p = parseInt(ts.parents('.pagination:first').find('.next').prev().text());
                        else
                            p = parseInt(ts.text());

                        var cp = $('input[name=page]', _form);
                        if (cp.length == 0)
                            _form.append('<input type="hidden" name="page"/>');

                        $('input[name=page]', _form).val(p);

                        _form.submit();

                        return false;
                    });
                }
            });
        }
    };
})(jQuery);