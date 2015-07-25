class Video < ActiveRecord::Base


scope :recents, where('created_at < ?', DateTime.now)
  validates_presence_of :avatar
  has_attached_file :avatar,
 :styles => {
      :mp4video => { :geometry => "640x480", :format => 'mp4', :convert_options => {:output => {:ar => 44100}} },
      :webmvideo =>{ :geometry => "1024x576", :format => 'webm', :convert_options => {:output => {:ar => 44100}} },
      :oggvideo => { :geometry => "1024x576", :format => 'ogg', :convert_options => {:output => {:ar => 44100}} }
   },
    processors: [:ffmpeg],
    :max_size => 25.megabytes,  
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"

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
