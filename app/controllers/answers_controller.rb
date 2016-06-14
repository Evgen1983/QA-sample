class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [ :create, :update, :destroy]
  before_action :set_question, only: [ :create ]
  before_action :set_answer, only: [ :update, :destroy]
  
  
  def create
     @answer = @question.answers.create(answer_params)
     @answer.user = current_user
     @answer.save
  end
  
  def update
    @answer.update(answer_params)
    @question = @answer.question
  end

  def destroy
    if author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Your answer successfully destroyed.'
      redirect_to question_path(@answer.question)
    else
      flash[:notice] = "You can't delete question."
      redirect_to question_path(@answer.question)
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
    params.require(:answer).permit(:body)
  end
end
