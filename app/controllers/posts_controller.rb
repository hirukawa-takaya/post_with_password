class PostsController < ApplicationController
  before_action :set_post     , only: [:show, :edit, :update, :destroy]
  before_action :with_password, only: :show

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  
  def authenticate
    post_id = Post.find(params[:id])
    if post_id && post_id.authenticate(params[:post][:password])
      redirect_to post_path(post_id, parameter: post_id.password_digest)
    else
      render 'posts_with_password'
    end
  end

  def posts_with_password
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:description, :password, :parameter)
    end
    
  def with_password
    url = request.url.gsub!(/%21|%22|%23|%24|%24|%25|%26|%27|%28|%29|%2A|%2B|%2C|%2F|%3A|%3B|%3C|%3D|%3E|%3F|%40|%5B|%5D|%5E|%60|%7B|%7C|%7D|%7E|/,
    "%21" => "!", "%22" => '"', "%23" => "#", "%24" => "$", "%25" => "%", "%26" => "&", "%27" => "'", "%28" => "(", "%29" => ")",
    "%2A" => "*", "%2B" => "+", "%2C" => ",", "%2F" => "/", "%3A" => ":", "%3B" => ";", "%3C" => "<", "%3D" => "=", "%3E" => ">", "%3F" => "?", "%40" => "@",
    "%5B" => "[", "%5D" => "]", "%5E" => "^", "%60" => "`", "%7B" => "{", "%7C" => "|", "%7D" => "}", "%7E" => "~")
    @post = Post.find(params[:id])
    if !@post.password_digest.nil? && !url.try(:include?, @post.password_digest)
      redirect_to "/posts_with_password/#{@post.id}", danger: 'パスワードを入力してください'
    end
  end
end
