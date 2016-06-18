require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

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

      it "redirects to question view" do
        delete :destroy, id: answer, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

end
