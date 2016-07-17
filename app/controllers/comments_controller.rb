class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [ :create ]
  
  after_action :comment_pub, only: :create

  respond_to :js

  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commentable
    params[:commentable].singularize
  end

  def comment_pub
    PrivatePub.publish_to('/comments', comment: @comment.to_json) if @comment.persisted?
  end


  def load_commentable
    @commentable = set_commentable.classify.constantize.find(params["#{set_commentable}_id"])
  end
end
