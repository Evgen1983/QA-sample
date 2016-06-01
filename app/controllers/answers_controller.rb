class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_action :set_question, only: [:new, :create]
  before_action :set_answer, only: [:edit, :update, :destroy]
  
  def new
	 @answer = @question.answers.new
  end

  def edit
  end
  
  def create
     @answer = @question.answers.create(answer_params)
     @answer.user = current_user
    if @answer.save
      redirect_to question_path(@question)
    else
      render :new
    end	
  end
  
  def update
    if
      @answer.update(answer_params)
      redirect_to question_path(@answer.question)
    else
      render :edit
    end
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
