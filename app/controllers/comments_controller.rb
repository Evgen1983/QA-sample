class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_commentable, only: [ :create ]

  def create
    @comment = @commentable.comments.build(comment_params.merge(user: current_user))
    respond_to do |format|
      if @comment.save
        format.js do
          PrivatePub.publish_to('/comments', comment: @comment.to_json)
          render  nothing: true 
        end
      else
      	format.js
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_commentable
    params[:commentable].singularize
  end

  def load_commentable
    @commentable = set_commentable.classify.constantize.find(params["#{set_commentable}_id"])
  end
end
