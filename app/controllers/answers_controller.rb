class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!, only: [ :create, :update, :destroy]
  before_action :set_question, only: [ :create ]
  before_action :set_answer, only: [ :update, :destroy, :best_answer]
  
  
  def create
     @answer = @question.answers.create(answer_params)
     @answer.user = current_user
     @answer.save
  end
  
  def update
    if author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def best_answer
    if author_of?(@answer)
      @answer.set_best!
      @question = @answer.question
    end
  end

  def destroy
    if author_of?(@answer)
      @answer.destroy
    end
  end

  private
  
  def set_question
    @question = Question.find(params[:question_id])
  end


  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:id, :file, :_destroy])
  end
end
