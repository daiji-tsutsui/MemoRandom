class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :existing_post, only: [:show, :edit, :update, :destroy]

  def top
    if params[:word] == 'login'
      redirect_to login_url and return
    elsif params[:word].present?
      @posts = Post.where("name LIKE ?", "%" + params[:word] + "%")
                .order('created_at desc').paginate(page: params[:page])
    else
      @posts = Post.all.order('created_at desc').paginate(page: params[:page])
    end
  end

  def new
    @post = @user.posts.build()
  end

  def create
    name = post_params_multi[:name]
    flash[:success] = []
    flash[:danger] = []

    post_params_multi[:memo].each do |memo|
      @post = @user.posts.build(name: name, memo: memo)
      @post.name = name_post(@post) if @post.name.blank?
      @post.created_at = timestamp_post(@post)
      if @post.save
        flash[:success].push(memo.original_filename)
      else
        flash[:danger] += @post.error_print(original_filename(@post.memo.url))
      end
    end

    flash[:success].unshift('Successfully create: ') if flash[:success].size >= 1
    if flash[:danger].size >= 1
      flash[:danger].unshift('Fail to create: ')
      redirect_to new_post_path and return
    end
    redirect_to top_path
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
      flash[:danger] = @post.error_print("Fail to update...")
      redirect_to edit_post_path(@post)
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Post was successfully deleted."
      redirect_to top_url
    else
      flash[:danger] = @post.error_print("Fail to delete...")
      redirect_to request.referer
    end
  end

  def readme
    @posts = Post.where("name LIKE ?", "%readme%")
    if @posts.count == 1
      redirect_to @posts[0]
    else
      redirect_to top_url(word: 'readme')
    end
  end

  private

    def post_params
      params.require(:post).permit(:name, :memo)
    end

    def post_params_multi
      params.require(:post).permit(:name, {memo: []})
    end

    def logged_in_user
      @user = User.find_by(id: current_user.id) if logged_in?
      if @user.nil?
        flash[:danger] = "Need to log in."
        redirect_back_or(top_url) and return false
      end
      return true
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
