class Video < ActiveRecord::Base

MISSING_VIDEO_URL_PLACEHOLDER = '/assets/no-video.jpg'

##GET ALL CREATED 2 DASY AGO
scope :recents, where("created_at < ?", 2.days.ago)
  validates_presence_of :avatar
  has_attached_file :avatar,
  :styles => {
      :mp4video => { :geometry => '520x390', :format => 'mp4',
        :convert_options => { :output => { :vcodec => 'libx264',
          :acodec => 'libfaac' } } },
      :webmvideo => { :geometry => '520x390', :format => 'webm',
      :convert_options => { :output => { :vcodec => 'libvpx',
        :acodec => 'libvorbis'} } }, 
      :oggvideo => { :geometry => '520x390', :format => 'ogg',
        :convert_options => { :output => { :vcodec => 'libtheora',
          :acodec => 'libvorbis' } } }
       
    },
    processors: [:ffmpeg],
    :max_size => 25.megabytes,  
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
    
    
# before_post_process do
#   file = avatar.queued_for_write[:original].path
#   self.duration = Paperclip.run("ffprobe", '-i %s -show_entries format=duration -v quiet -of csv="p=0"' % file).to_f
#   Rails.logger.info "========================================CALCULATING VIDEO DURATION============= #{self.duration}===="
# end    



##################### CLASS METHODS ##################################
class << self

  def delete_database_and_files_on_server
  recents=Video.recents
    if recents
      recents.each do |v|
        v.delete
        FileUtils.rm_rf("#{Rails.root}"+"/public/system/avatars/#{v.id}")    
      end  
    end
  end  
  
end##self ends

###################### INSTANCE METHODS ##############################
###############################################INSTANCE METHODS ##################################################################
def to_videoupload_error
 {
      "name" => read_attribute(:avatar_file_name),
      "size" => read_attribute(:avatar_file_size),
      "url" =>  Video::MISSING_VIDEO_URL_PLACEHOLDER,
      "thumbnailUrl" => Video::MISSING_VIDEO_URL_PLACEHOLDER,
      # "deleteUrl" => "/picture/#{self.id}",
      # "deleteType" => "DELETE",
      "error"=> errors.full_messages
    }
end

def to_videoupload_success
 {
      "name" => read_attribute(:avatar_file_name),
      "size" => read_attribute(:avatar_file_size),
      "url" =>  self.avatar.url.to_s,
      "thumbnailUrl" => self.avatar.url.to_s,
      "video_id" => self.id,
      "success" => "Video uploaded"
      # "deleteUrl" => "halls/#{self.hall_id}/pictures/#{self.id}",
      # "deleteType" => "DELETE"
    }
end
 


end
