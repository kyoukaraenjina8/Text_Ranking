class Public::CommentsController < ApplicationController

  def create
      post_comment = Post.find(params[:post_id])
      comment = Comment.new(post_comment_params)
      comment.user_id = current_user.id
      comment.post_id = post_comment.id
    if comment.save
      redirect_to post_path(post_comment.id)
      flash[:notice] = '新規コメントを作成しました。'
    else
      redirect_to post_path(post_comment.id)
      flash[:alert] = '新規コメントを作成できませんでした。'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy
    flash[:notice] = 'コメントを削除しました。'
    redirect_to request.referer
  end

  private

  def post_comment_params
    params.require(:comment).permit(:comment_introduction, :total_score, :read_score, :price_score, :usability_score)
  end

end
