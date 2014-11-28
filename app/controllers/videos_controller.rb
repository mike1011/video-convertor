class VideosController < ApplicationController
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
    @video = Video.new
    Video.delete_database_and_files_on_server
   

    respond_to do |format|
      format.js
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
    p params
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
