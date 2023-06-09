class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @users = User.page(params[:page])
  end

  def edit
    @admin_edit = User.find(params[:id])
  end

  def update
    @admin_edit = User.find(params[:id])
    if @admin_edit.update(user_params)
      flash[:notice] = 'ユーザー情報の編集成功しました。'
      redirect_to admin_users_path
    else
      render 'edit'
    end
  end

  def show
    @user_post = User.find(params[:id])
    @posts = @user_post.posts.all
    @user_comment = User.find(params[:id])
    @comments = @user_comment.comments.all
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :is_deleted, :encrypted_password)
  end
end
