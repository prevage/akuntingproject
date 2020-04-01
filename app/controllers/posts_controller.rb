class PostsController < ApplicationController
  before_action :authenticate_employee!
  before_filter :post, only: [:destroy]

  respond_to  :js, :json

  def index
    @posts = Post.all.order('created_at DESC')

    respond_with(@posts)
  end

  def new
    #@post = Post.new

    #respond_with(@post)
  end

  def create
    @posts = Post.all
    @post = profile.posts.create!(posts_params)
  end

  def update
  end

  def destroy
    @post.destroy!
    respond_to do |format|
      format.js   { render :layout => false }
    end
  end

  private

  def posts_params
    params.require(:post).permit(:profile_id, :content)
  end

  def post
    @post = profile.posts.find(params[:id])
  end
end
