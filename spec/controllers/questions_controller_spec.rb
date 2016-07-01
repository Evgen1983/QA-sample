require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
	describe 'GET #index' do
	  let(:questions) { create_pair(:question) }
	  before { get :index }
	  it 'populates an array of all questions' do
	  	expect(assigns(:questions)).to eq Question.all
	  end
	  it 'renders index view' do
	  	expect(response).to render_template :index
	  end
	end

	describe 'GET #show'do
	  before { get :show, id: question }
	  it 'assings the requested question to @question' do
      expect(assigns(:question)).to eq question
      end

    it 'assigns new answer for question' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'builds new attachment for answer' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end

    it 'renders show view' do
      expect(response).to render_template :show 
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }
    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'builds new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end


  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'saves the new question in the database' do
        expect { post :create, question: attributes_for(:question) }.to change(Question, :count).by(1)
      end

      it 'associate question to user and save in db'do
        expect { post :create, question: attributes_for(:question) }.to change(@user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, question: attributes_for(:question)
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, question: attributes_for(:invalid_question) }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, question: attributes_for(:invalid_question)
        expect(response).to render_template :new
      end
    end
  end

   describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      let(:question) { create(:question, user: @user ) }
      it 'assings the requested question to @question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(assigns(:question)).to eq question
      end

      it 'changes question attributes' do
        patch :update, id: question, question: { title: 'new title' * 5, body: 'new body' * 10 }, format: :js
        question.reload
        expect(question.title).to eq 'new title' * 5
        expect(question.body).to eq 'new body' * 10
      end

      it 'redirects to the updated question' do
        patch :update, id: question, question: attributes_for(:question), format: :js
        expect(response).to render_template :update
      end
    end

    context 'invalid attributes' do
      before { patch :update, id: question, question: { title: 'new title', body: nil}, format: :js }

      it 'does not change question attributes' do
        question.reload
        expect(question.title).to eq question[:title]
        expect(question.body).to eq question[:body]
      end

      it 're-renders update template' do
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    context "author try to delete question" do
    let(:question) { create(:question, user: @user) }
      it 'deletes question' do
        question
        expect { delete :destroy, id: question }.to change(Question, :count).by(-1)
      end


      it 'redirect to index view' do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
        expect(flash[:notice]).to be_present
      end
    end

    context "not the author  try to delete question" do
      it "doesnt delete question" do
        question
        expect { delete :destroy, id: question }.to_not change(Question, :count)
      end

      it "redirects to index view" do
        delete :destroy, id: question
        expect(response).to redirect_to questions_path
        expect(flash[:notice]).to be_present
      end
    end
  end
end
