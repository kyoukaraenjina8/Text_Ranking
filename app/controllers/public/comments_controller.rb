class Public::CommentsController < ApplicationController

  def create
    post_comment = Post.find(params[:post_id])
    comment = Comment.new(post_comment_params)
    comment.user_id = current_user.id
    comment.post_id = post_comment.id
    if comment.save
    redirect_to post_path(post_comment.id)
    else
    render template: "posts/show(post_comment.id)"
    end
  end
  def index
    @comments = Comment.all
  end
  
  def destroy
    Comment.find(params[:id]).destroy
    redirect_to posts_path
  end
  
  private

  def post_comment_params
    params.require(:comment).permit(:comment_introduction, :total_score, :read_score, :price_score, :usability_score)
  end
  
end
