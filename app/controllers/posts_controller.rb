class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :existing_post, only: [:show, :edit, :update, :destroy]

  def top
    @posts = Post.all
  end

  def new
    @post = @user.posts.build()
  end

  def create
    @post = @user.posts.build(post_params)
    @post.name = name_post(@post) if @post.name.blank?
    if @post.save
      flash[:success] = "Post was successfully created."
      redirect_to post_url(@post)
    else
      flash[:danger] = "Fail to create..."
      redirect_to post_new_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post was successfully updated."
      redirect_to post_url(@post)
    else
      flash[:danger] = "Fail to create..."
      redirect_to edit_post_path(@post)
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Post was successfully deleted."
      redirect_to top_url
    else
      flash[:danger] = "Fail to delete..."
      redirect_to request.referer
    end
  end

  private

    def post_params
      params.require(:post).permit(:name, :memo)
    end

    def logged_in_user
      @user = User.find_by(id: current_user.id)
      if @user.nil?
        flash[:danger] = "You need to log in."
        redirect_to top_url and return
      end
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      if @post.nil?
        flash[:danger] = "Incorrect user's operation."
        redirect_to top_url and return
      end
    end

    def existing_post
      @post = Post.find_by(id: params[:id])
      if @post.nil?
        flash[:danger] = "This post does not exist."
        redirect_to top_url and return
      end
    end
end
