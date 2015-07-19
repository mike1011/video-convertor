class Video < ActiveRecord::Base


scope :recents, where('created_at < ?', DateTime.now)
  validates_presence_of :avatar
  has_attached_file :avatar,
 :styles => {
      :mp4video => { :geometry => '520x390', :format => 'mp4',
        :convert_options => { :output => { :vcodec => 'libx264',
          :vpre => 'ipod640', :b => '250k', :bt => '50k',
          :acodec => 'libfaac', :ab => '56k', :ac => 2 } } },
      :webmvideo => { :geometry => '520x390', :format => 'webm',
      :convert_options => { :output => { :vcodec => 'libvpx',
        :b => '250k', :bt => '50k', :acodec => 'libvorbis',
        :ab => '56k', :ac => 2 } } }, 
      :oggvideo => { :geometry => '520x390', :format => 'ogg',
        :convert_options => { :output => { :vcodec => 'libtheora',
          :b => '250k', :bt => '50k', :acodec => 'libvorbis',
          :ab => '56k', :ac => 2 } } },   
       :preview => { :geometry => '300x300>', :format => 'jpg', :time => 5 }
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
