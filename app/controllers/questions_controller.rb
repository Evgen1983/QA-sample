class QuestionsController < ApplicationController
  include Voted
  before_action :authenticate_user!, only: [ :new, :create ]
  before_action :load_question, only: [:show, :update, :destroy]
  before_action :build_answer, only: [:show]
  after_action :question_pub, only: [:create]
  respond_to :js, only: :update
  def index
  	respond_with(@questions = Question.all)
  end

  def show
    respond_with(@question)
  end

  def new
  	respond_with(@question = Question.new) 
  end


  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def update
    @question.update(question_params) if author_of?(@question)
    respond_with(@question)
  end
  
  def destroy
    @question.destroy if author_of?(@question)
    respond_with(@question)
  end

  private
    
    def load_question
      @question = Question.find(params[:id])
    end

    def build_answer
      @answer = @question.answers.build
    end

    def question_pub
      PrivatePub.publish_to "/questions", question: @question.to_json if @question.valid?
    end

    def question_params
      params.require(:question).permit(:title, :body, attachments_attributes: [:id, :file, :_destroy])
    end
end
