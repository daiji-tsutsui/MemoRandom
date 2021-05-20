class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  def top
    @posts = Post.all
  end

  def new
    @post = @user.posts.build()
  end

  def create
    @post = @user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post was successfully created."
      redirect_to post_url(@post)
    else
      flash[:danger] = "Failure..."
      redirect_to post_new_path
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
  end

  def destroy
  end

  private

    def post_params
      params.require(:post).permit(:name, :memo)
    end

    def logged_in_user
      if current_user.present?
        @user = current_user
      else
        redirect_to top_url and return
      end
    end
end
