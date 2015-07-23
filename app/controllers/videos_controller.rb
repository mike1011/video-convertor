class VideosController < ApplicationController

require 'open-uri'
require 'viddl-rb'


  # GET /videos
  # GET /videos.json
  def index
    @videos = Video.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @videos }
    end
  end

  # GET /videos/1
  # GET /videos/1.json
  def show
    @video = Video.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/new
  # GET /videos/new.json
  def new
    Video.delete_database_and_files_on_server
    @video = Video.new
   

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @video }
    end
  end

  # GET /videos/1/edit
  def edit
    @video = Video.find(params[:id])
  end

  # POST /videos
  # POST /videos.json
  def create
    @video = Video.new(params[:video])
    if @video.save
                 respond_to do |format|  
                  flash.now[:error]="Video converted successfully"
                    format.js
                 end   
    else
              respond_to do |format|  
                Rails.logger.info "CONVERSION FAILED=================="
                #flash.now[:error]="Add a video file"
                flash.now[:error]="#{@video.errors.full_messages.join(', ')}"
                format.js { render 'shared/show_error',:locals=>{:type=>"Video"}}
              end  
    end   
 end

  # PUT /videos/1
  # PUT /videos/1.json
  def update
    @video = Video.find(params[:id])

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @video.errors, status: :unprocessable_entity }
      end
    end
  end

  def send_video
    @video=Video.find params[:video_id]

    case params[:con]
    when "mp4"
        send_file "#{Rails.root}/public#{@video.avatar.url(:mp4video).split("?").first}",:x_sendfile => true      
    when "ogg"
        send_file "#{Rails.root}/public#{@video.avatar.url(:oggvideo).split("?").first}",:x_sendfile => true
    when "webm"
        send_file "#{Rails.root}/public#{@video.avatar.url(:webmvideo).split("?").first}",:x_sendfile => true
    when "original"
        send_file "#{Rails.root}/public#{@video.avatar.url.split("?").first}",:x_sendfile => true        
     when "flv"
         send_file "#{Rails.root}/public#{@video.avatar.url(:flvvideo).split("?").first}",:x_sendfile => true        
    end



  end


def get_youtube_video
  # @video = YoutubeVideo.new(params[:youtube_video])
  # if @video.save!
  # end  
# link=params[:youtube_video][:link]
# p link
# download_urls = ViddlRb.get_urls(link)
# download_urls.first     # => "http://o-o.preferred.arn06s04.v3.lscac ..."
    
  #YouTubeLinks = ["https://www.youtube.com/watch?v=Z8wLQ3NCBgg","https://www.youtube.com/watch?v=QH2-TGUlwu4"]

youtube_hashes = ["https://www.youtube.com/watch?v=Z8wLQ3NCBgg","https://www.youtube.com/watch?v=QH2-TGUlwu4"].map do |link|
  ViddlRb.get_urls_names(link).first
end

youtube_hashes.each do |yt|
  puts "Downloading: #{yt[:name]}"

  File.open(yt[:name], 'wb') do |video_file|
    open(yt[:url]) { |video| video_file.write video.read }
  end
end



end





  # DELETE /videos/1
  # DELETE /videos/1.json
  def destroy
    @video = Video.find(params[:id])
    @video.destroy

    respond_to do |format|
      format.html { redirect_to videos_url }
      format.json { head :no_content }
    end
  end
end
