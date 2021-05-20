class PostsController < ApplicationController
  def top
    @posts = Post.all
  end

  def new
    @user = current_user
    @post = @user.posts.build()
  end

  def create
  end

  def show
    @user = current_user
    @post = @user.posts.build()
  end

  def edit
    @user = current_user
    @post = @user.posts.build()
  end

  def destroy
  end
end
