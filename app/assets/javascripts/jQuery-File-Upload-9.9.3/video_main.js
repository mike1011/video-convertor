/*
 * jQuery File Upload Plugin JS Example 8.9.1
 * https://github.com/blueimp/jQuery-File-Upload
 *
 * Copyright 2010, Sebastian Tschan
 * https://blueimp.net
 *
 * Licensed under the MIT license:
 * http://www.opensource.org/licenses/MIT
 */

/* global $, window */

$(function () {
    'use strict';

    // Initialize the jQuery File Upload widget:
    $('#videoupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
        //27feb2015-commented as i want to use the action of the form or url of current page
        url: '/videos',
        //TODO-GOOD-8feb-added max and type filter to use only images/audios/videos etc within different scripts
        //25mb video
        maxFileSize: 25000000,
        //2mb
        minFileSize:'2000000',
        acceptFileTypes: /(\.|\/)(mp4|webm|avi|flv|ogv|3gp|rm|swf|wmv|mov|)$/i,
        maxNumberOfFiles: 1,
        disableImageResize: /Android(?!.*Chrome)|Opera/
            .test(window.navigator.userAgent),
        // Error and info messages:
            messages: {
                // maxNumberOfFiles: 'Maximum number of files exceeded',
                acceptFileTypes: 'File type not allowed',
                maxFileSize: 'File size should be less than 20 MB',
                minFileSize: 'File size should be more than 2 Mb'
                // maxFileSize: 'File is too large',
                // minFileSize: 'File is too small'
            }

    });

    // Enable iframe cross-domain access via redirect option:
    $('#videoupload').fileupload(
        'option',
         {
            previewMaxWidth: 180,
            previewMaxHeight: 150
         },
        'redirect',
        window.location.href.replace(
            /\/[^\/]*$/,
            '/cors/result.html?%s'
        )
    );

    if (window.location.hostname === 'blueimp.github.io') {
        // Demo settings:
        $('#videoupload').fileupload('option', {
            url: '//jquery-file-upload.appspot.com/',
            // Enable image resizing, except for Android and Opera,
            // which actually support image resizing, but fail to
            // send Blob objects via XHR requests:
            disableImageResize: /Android(?!.*Chrome)|Opera/
                .test(window.navigator.userAgent),
            maxFileSize: 2000000,
            acceptFileTypes: /(\.|\/)(gif|jpe?g|png)$/i

        });
        // Upload server status check for browsers with CORS support:
        if ($.support.cors) {
            $.ajax({
                url: '//jquery-file-upload.appspot.com/',
                type: 'HEAD'
            }).fail(function () {
                $('<div class="alert alert-danger"/>')
                    .text('Upload server currently unavailable - ' +
                            new Date())
                    .appendTo('#videoupload');
            });
        }
    } else {
        // Load existing files:
        $('#videoupload').addClass('fileupload-processing');
        $.ajax({
            // Uncomment the following to send cross-domain cookies:
            //xhrFields: {withCredentials: true},
        url: '/videos',
            dataType: 'json',
            context: $('#videoupload')[0]
        }).always(function () {
            $(this).removeClass('fileupload-processing');
        }).done(function (result) {
            $(this).fileupload('option', 'done')
                .call(this, $.Event('done'), {result: result});
        });
    }

});
