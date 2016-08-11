class Video < ActiveRecord::Base


scope :recents, where('created_at < ?', DateTime.now)
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
    
    
before_post_process do
  file = video.queued_for_write[:original].path
  self.duration = Paperclip.run("ffprobe", '-i %s -show_entries format=duration -v quiet -of csv="p=0"' % file).to_f
  Rails.logger.info "========================================CALCULATING VIDEO DURATION============= #{self.duration}===="
end    

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



end
