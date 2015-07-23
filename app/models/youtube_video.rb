class YoutubeVideo < ActiveRecord::Base
  attr_accessible :author, :link, :title, :uid

  YT_LINK_FORMAT = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
 validates :link, presence: true, format: YT_LINK_FORMAT

 before_create -> do
  uid = link.match(YT_LINK_FORMAT)
  self.uid = uid[2] if uid && uid[2]
 
  if self.uid.to_s.length != 11
    self.errors.add(:link, 'is invalid.')
    false
  elsif YoutubeVideo.where(uid: self.uid).any?
    self.errors.add(:link, 'is not unique.')
    false
  else
    get_additional_info
  end
end




private
 
def get_additional_info
  begin
    ##client = YouTubeIt::OAuth2Client.new(dev_key: 'AI39si5W6tVVzCrorngp5K2AZkUT1zzT7aAOvEV62JqKdTfNbZKFMw88QPRe52eYyIgACuoafwzGgQ1LGZAI3owHIc5cub3L5Q')
    client = YouTubeIt::Client.new(:username => "Milind", :password =>  "catchmeifyoucan@123", :dev_key => "AI39si5W6tVVzCrorngp5K2AZkUT1zzT7aAOvEV62JqKdTfNbZKFMw88QPRe52eYyIgACuoafwzGgQ1LGZAI3owHIc5cub3L5Q")    
    video = client.video_by(uid)
    self.title = video.title
    self.author = video.author.name
    
  rescue
    self.title = '' ; self.author = '' 
  end
end
 
def parse_duration(d)
  hr = (d / 3600).floor
  min = ((d - (hr * 3600)) / 60).floor
  sec = (d - (hr * 3600) - (min * 60)).floor
 
  hr = '0' + hr.to_s if hr.to_i < 10
  min = '0' + min.to_s if min.to_i < 10
  sec = '0' + sec.to_s if sec.to_i < 10
 
  hr.to_s + ':' + min.to_s + ':' + sec.to_s
end



end
