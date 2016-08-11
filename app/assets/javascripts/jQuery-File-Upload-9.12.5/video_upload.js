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

    //var upload_data = new FormData($('#fileupload')[0]);
    // Initialize the jQuery File Upload widget:
    $('#videoupload').fileupload({
        // Uncomment the following to send cross-domain cookies:
        //xhrFields: {withCredentials: true},
       // context:upload_data,
       //using json,not script because after success,we are updating the view using 
       //fileuploaddone callback and then user can see the latest uploaded files
        //dataType: 'script',
        cache: false,
        type: 'POST',
        dataType: 'json',
        autoUpload: true,
        singleFileUploads: true,
               
        //TODO-GOOD-8feb-added max and type filter to use only images/audios/videos etc within different scripts
        //20MB
        maxFileSize: 30000000,
        //0.1mb
        //minFileSize: 100000,
        acceptFileTypes: /(\.|\/)(ogg|ogv|avi|mpe?g|mov|wmv|flv|mp4)$/i,
        //only 1 video
        maxNumberOfFiles: 1,
      
        //singleFileUploads: false,


                // Error and info messages:
            messages: {
                maxNumberOfFiles: 'You can only add 1 video',
                acceptFileTypes: 'Video type not allowed',
                maxFileSize: 'Video size should be less than 30 MB',
                minFileSize: 'Video size too small'
            }

         

    });




// $('#videoupload').bind('fileuploaddone', function (e, data) {

//          //$(".panel-body").find("div.image-preview").hide();
//          //var responseText = JSON.parse(data.jqXHR.responseText);
//          //console.log(responseText);
//          $(".panel-body").find("div.image-preview").hide();
//          var hall_id= $("#hall_id").val();
//          $("table#videoUploadPreview tbody.files").html("<tr class='text-center successMsgFileUpload text-info col-md-12 alert alert-success'><td colspan='3'>Video uploaded successfully.<a class='btn btn-primary' href='/halls/"+hall_id+"/videos'>View now</a>  </td></tr>");


//  });

//for success
//added callback to html using promise
// $('#fileupload').bind('fileuploaddone', function (e, data) {

//         $("#table_preview_uploads tbody").html("<tr class='text-center '><td colspan='3'>Files uploaded successfully,However they will get live within 24hrs to avoid spamming.</td></tr>").promise().done(function(){
//         //your callback logic / code here
//         $("#reset_uploads_btn,#submit_uploads_btn,#upload_new_notice").remove();
//         $("#add_uploads_btn").html("<a href='/photos' title='View My Photos' style='text-decoration:none;color:#000;'>View</a> | <a href='/photos/category' title='Add more photos' style='text-decoration:none;color:#000;'>Add More</a>");
//         });
// })

// //for failed
// $('#fileupload').bind('fileuploadfail', function (e, data) {

//     $("#upload_div").html("Files uploaded successfully");
// })

    // Enable iframe cross-domain access via redirect option:
     $('#videoupload').fileupload(
         'option',
          {
    //          previewMaxWidth: 200,
    //          previewMaxHeight: 200,
    //          uploadTemplateId: null,
    // downloadTemplateId: null,

            // The container for the list of files. If undefined, it is set to
            // an element with class "files" inside of the widget element:
            //filesContainer: $('table#videouploadPreview > .videouploadFile')
          },
         'redirect',
         window.location.href.replace(
             /\/[^\/]*$/,
             '/cors/result.html?%s'
         )
     );



});
