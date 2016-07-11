class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, only: [ :new, :create ]
  before_action :load_question, only: [:show, :update, :destroy]
  def index
  	@questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
  	@question = Question.new
    @question.attachments.build
  end


  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
      PrivatePub.publish_to "/questions", question: @question.to_json
    else
      render :new
    end
  end

  def update
    if author_of?(@question)
      @question.update(question_params)
    end
  end
  
  def destroy
    if author_of?(@question)
      @question.destroy
      flash[:notice] = 'Your question successfully destroyed.'
      redirect_to questions_path
    else
      flash[:notice] = "You can't delete question."
      redirect_to questions_path
    end
  end

  private
    
    def load_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end
end
