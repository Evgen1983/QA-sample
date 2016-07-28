require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  it_behaves_like 'voted'

  let(:question) { create :question }
  let(:answer) { create :answer }

  describe 'POST #create' do
    sign_in_user
    context 'with valid attributes' do
      it 'save the new answer in the database' do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(question.answers, :count).by(1)  	
      end

      it 'associate answer to user and save in db'do
        expect { post :create, answer: attributes_for(:answer), question_id: question, format: :js }.to change(@user.answers, :count).by(1)
      end

      it 'render create temlate' do
      	post :create, answer: attributes_for(:answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js }.to_not change(Answer, :count)
      end

      it 'render create temlate' do
        post :create, answer: attributes_for(:invalid_answer), question_id: question, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'POST #update' do
    sign_in_user
    context "author try to update answer" do
      let(:answer) { create(:answer, question: question, user: @user) }
      it "assign requested answer to @answers" do
        patch :update, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'assigns to question' do
        patch :update, id: answer, question_id: question, user_id: @user, answer: attributes_for(:answer), format: :js
        expect(assigns(:question)).to eq question
      end

      it "change answer attributes" do
        patch :update, id: answer, question_id: question, answer: { body: 'new body' * 10 }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body' * 10
      end

      it 'render update template' do
        patch :update, id: answer, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :update
      end
      
      context 'with invalid attributes' do
        it 'does not change answer attributes' do
          patch :update, id: answer, question_id: question, answer: { body: nil }, format: :js
          answer.reload
          expect(answer.body).to_not eq nil
        end

        it 'render update temlate with invalid attributes' do
          patch :update, id: answer, question_id: question, answer: attributes_for(:invalid_answer), format: :js
          expect(response).to render_template :update
        end
      end

    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    context "author try to delete answer" do
    let(:answer) { create(:answer, user: @user) }
      it 'deletes answer' do
        answer
        expect { delete :destroy, id: answer, format: :js }.to change(Answer, :count).by(-1)
      end


      it 'redirect to question view' do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end

    context "not the author  try to delete answer" do
      it "doesnt delete answer" do
        answer
        expect { delete :destroy, id: answer, format: :js }.to_not change(Answer, :count)
      end

      it "redirects to root_url" do
        delete :destroy, id: answer, format: :js
        expect(response).to redirect_to root_url
      end
    end
  end

  describe 'PATCH #best_answer' do
    
    it "Not Authenticated user can't accept answer as the best " do
      patch :best_answer, id: answer, question_id: question, answer: { best: true }, format: :js
      expect(answer.best).to eq false
    end
    
    context "Authenticated user" do
      sign_in_user
      let!(:question_1){ create(:question, user: @user) }
      let!(:answer_1){ create(:answer, question: question_1) }
      let!(:answer_2){ create(:answer, question: question_1) }
     
      it "can't accept the best answer" do
        patch :best_answer, id: answer, question_id: question, format: :js
        expect(answer.best).to eq false
      end

      it  "and author of the question can accept only one answer as the best" do
        
        expect(answer_1.best).to eq false
        expect(answer_2.best).to eq false

        patch :best_answer, id: answer_1, question_id: question_1, format: :js
        expect(assigns(:question)).to eq question_1
        expect(assigns(:answer)).to eq answer_1
        answer_1.reload
        
        expect(answer_1.best).to eq true
        expect(answer_2.best).to eq false

        patch :best_answer, id: answer_2, question_id: question_1, format: :js

        expect(assigns(:question)).to eq question_1
        expect(assigns(:answer)).to eq answer_2

        answer_2.reload
        expect(answer_2.best).to eq true
        answer_1.reload
        expect(answer_1.best).to eq false
      end
    end
  end

end
