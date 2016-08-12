//= require jQuery-File-Upload-9.12.5/jquery.ui.widget
//= require jQuery-File-Upload-9.12.5/tmpl.min
//= require  jQuery-File-Upload-9.12.5/load-image.all.min
//= require  jQuery-File-Upload-9.12.5/canvas-to-blob.min
//= require  jQuery-File-Upload-9.12.5/jquery.blueimp-gallery.min
//= require jQuery-File-Upload-9.12.5/jquery.iframe-transport
//= require  jQuery-File-Upload-9.12.5/jquery.fileupload
//= require jQuery-File-Upload-9.12.5/jquery.fileupload-process
//= require jQuery-File-Upload-9.12.5/jquery.fileupload-image
//= require jQuery-File-Upload-9.12.5/jquery.fileupload-video
//= require jQuery-File-Upload-9.12.5/jquery.fileupload-validate
//= require jQuery-File-Upload-9.12.5/jquery.fileupload-ui
//= require jQuery-File-Upload-9.12.5/video_upload


/*global $*/


$(document).ready(function(){
    
    $('video').mediaelementplayer({
					// when this player starts, it will pause other players
    				pauseOtherPlayers: true,
    			    toggleCaptionsButtonWhenOnlyOne: true,
				    // enables Flash and Silverlight to resize to content size
				    enableAutosize: true
    });
				
    
    
})
