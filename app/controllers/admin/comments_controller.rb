class Admin::CommentsController < ApplicationController
  layout "layouts/admin_application"

  def index
    @tweet          = Tweet.find(params[:tweet_id])
    @tweet_comments = @tweet.comments.all
  end


  def update
    @comment = Comment.find(params[:id])
    if @comment.is_active?
      @comment.update(is_active: false)
      redirect_to admin_tweet_comments_path(@comment.tweet)
      flash[:notice] = "コメントを無効にしました。"
    else
      @comment.update(is_active: true)
      redirect_to admin_tweet_comments_path(@comment.tweet)
      flash[:notice] = "コメントを有効にしました。"
    end
  end

  def destroy
    tweet = Tweet.find(params[:tweet_id])
    Comment.find(params[:id]).destroy
    redirect_to admin_tweet_comments_path(tweet)
    flash[:notice] = "コメントの削除が完了しました。"
  end

end
