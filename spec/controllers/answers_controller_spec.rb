require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create :question }
  let(:answer) { create(:answer) }

  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end
  
  describe 'GET #edit' do
    sign_in_user
    before { get :edit, id: answer }

    it 'assings the requested answer to @answer' do
      expect(assigns(:answer)).to eq answer  
    end

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new answer in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(question.answers, :count).by(1)  	
      end

      it 'associate answer to user and save in db'do
        expect { post :create, answer: attributes_for(:answer), question_id: question }.to change(@user.answers, :count).by(1)
      end

      it 'redirect to show view' do
      	post :create, answer: attributes_for(:answer), question_id: question
        expect(response).to redirect_to question_path(assigns(:question))
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question }.to_not change(Answer, :count)
      end

      it 're-render new view' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question
        expect(response).to render_template :new
      end
    end
  end

  describe 'POST #update' do
    sign_in_user

    context 'with valid attributes' do
      it "assign requested answer to @answers" do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(assigns(:answer)).to eq answer
      end

      it "change answer attributes" do
        patch :update, id: answer, answer: { body: 'new body' * 10 }
        answer.reload
        expect(answer.body).to eq 'new body' * 10
      end

        it "redirect to answers question" do
        patch :update, id: answer, answer: attributes_for(:answer)
        expect(response).to redirect_to question_path(answer.question)
      end
    end

    context 'with invalid attributes' do
      it "does not change question attributes" do
        patch :update, id: answer, answer: { body: nil }
        answer.reload
        expect(answer.body).to eq answer[:body]
      end

      it "render edit view" do
        patch :update, id: answer, answer: { body: nil }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    context "author try to delete answer" do
    let(:answer) { create(:answer, user: @user) }
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer }.to change(Answer, :count).by(-1)
      end


      it 'redirect to question view' do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(answer.question)
        expect(flash[:notice]).to be_present
      end
    end

    context "not the author  try to delete answer" do
      it "doesnt delete answer" do
        answer
        expect { delete :destroy, id: answer }.to_not change(Answer, :count)
      end

      it "redirects to question view" do
        delete :destroy, id: answer
        expect(response).to redirect_to question_path(answer.question)
        expect(flash[:notice]).to be_present
      end
    end
  end

end
