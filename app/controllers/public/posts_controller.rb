class Public::PostsController < ApplicationController

  def new
    @post = Post.new
  end

  def index
    @posts = Post.all
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if@post.save
      flash[:notice] = '新規投稿に成功しました。'
      redirect_to posts_path
    else
      render :new
    end
  end

  def edit
    @post_edit = Post.find(params[:id])
  end

  def update
    @post_edit = Post.find(params[:id])
    if@post_edit.update(post_params)
      flash[:notice] = '投稿を編集しました。'
      redirect_to post_path(@post_edit)
    else
      render :edit
    end
  end

  def show
    @post = Post.find(params[:id])
    @post_comment = Comment.new
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    flash[:notice] = 'Textを削除しました。'
    redirect_to posts_path
  end

private

  def post_params
    params.require(:post).permit(:image,:text_name, :introduction, :review, :price, :total_score, :read_score, :price_score, :usability_score)
  end
end
