class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by(slug: params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.creator = current_user

    if @comment.save
      flash[:notice] = "Your comment was added"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    respond_to do |format|
      format.html do
        if @vote.valid?
          flash[:notice] = "Your vote was counted."
        else
          flash[:error] = "You have already voted for that comment"
        end

        redirect_to :back
      end
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end