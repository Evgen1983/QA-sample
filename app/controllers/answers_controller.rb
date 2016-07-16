class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!, only: [ :create, :update, :destroy ] 
  before_action :set_question, only: [ :create ]
  before_action :set_answer, only: [ :update, :destroy, :best_answer ]
  
  
  respond_to :js

  def create
   respond_with(@answer = @question.answers.create(answer_params.merge(user_id: current_user.id)))
  end
  
  def update
    @answer.update(answer_params) if author_of?(@answer)
    respond_with @answer
  end

  def best_answer
    @answer.set_best! if author_of?(@answer)
    respond_with @answer
  end

  def destroy
    @answer.destroy if author_of?(@answer)
    respond_with @answer
  end

  private
  
  def set_question
    @question = Question.find(params[:question_id])
  end


  def set_answer
    @answer = Answer.find(params[:id])
    @question = @answer.question
  end
  

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
