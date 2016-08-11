class VideosController < ApplicationController

require 'open-uri'
require 'viddl-rb'


  # GET /videos
  # GET /videos.json
  def index
    #@videos = Video.all
    Video.delete_database_and_files_on_server
    @video = Video.new

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
    respond_to do |format|
      if @video.save
          format.html { redirect_to hall_video_path(@hall,@video), notice: 'Video was successfully created.' }
          format.json { render json: {files: [@video.to_videoupload_success] }}
         ##format.js
         p @video.to_videoupload_success
      else
          format.html { render :new }
          format.json { render json: {files: [@video.to_videoupload_error] }}
      end
    end   
    p "======================="
    p @video.errors
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
 
 link=params[:youtube_video][:link]

 ##validate the link provided by the user
 @format = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i
 if link.present? &&  (link =~ @format)

     youtube_hashes = [link].map do |link|
      ViddlRb.get_urls_names(link).first
     end

     youtube_hashes.each do |yt|
      Rails.logger.info "====Downloading==========: #{yt[:name]}"
      File.open(yt[:name], 'wb') do |video_file|
        video_file << open(yt[:url]) { |video| video_file.write video.read }
        full_path = "#{Rails.root}/#{yt[:name]}"
        send_file full_path , filename: "#{yt[:name]}", type: "application/octet-stream" , disposition: 'inline' , stream: 'true', buffer_size: 4096 
      end 
     end
  else
   redirect_to root_url, :flash => { :error => "Provide a valid youtube link" }

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
