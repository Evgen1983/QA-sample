module Voted
  extend ActiveSupport::Concern

  
  included do
    before_action :find_votable, only: [ :vote_up, :vote_down, :vote_cancel ]
    before_action :not_owner, only: [:vote_up, :vote_down, :vote_cancel ]
  end

  def vote_up
    @votable.vote_up(current_user)
    respond_to do |format|
      format.json { render json: { id: @votable.id, score: @votable.total, status: true } } 
    end
  end

  def vote_down
   @votable.vote_down(current_user)
    respond_to do |format|
      format.json { render json: { id: @votable.id, score: @votable.total, status: true } } 
    end
  end

  def vote_cancel
    @votable.vote_cancel(current_user)
    respond_to do |format|
      format.json { render json: { id: @votable.id, score: @votable.total, status: false } } 
    end
  end

  private

  def find_votable
    @votable = model_klass.find(params[:id])
    authorize! action_name.to_sym, @votable
  end

  def model_klass
    controller_name.classify.constantize
  end

  def not_owner
    render nothing: true, status: 403 if @votable.user_id == current_user.id
  end

end