require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
	sign_in_user

  let(:question) { create(:question, user: @user) }
  let(:answer)   { create(:answer, question: question, user: @user) }

  describe 'POST #create for questions' do
    context 'with valid attributes' do
      let(:subject) { post :create, commentable: 'questions', question_id: question.id, comment: attributes_for(:comment), format: :js }

        it "save new comment in database" do
          expect { 
            subject
           }.to change(question.comments, :count).by(+1)
        end

        it "save new comment for user in database" do
          expect { 
            subject
            }.to change(@user.comments, :count).by(+1)
        end

        it_behaves_like 'publishable', "/comments"

        it "render nothing" do
          subject
          expect(response.body).to eq ""
        end
     end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create, commentable: 'question', question_id: question.id, comment: { body: nil }, format: :js }

      it "does not save comment for question in database" do
        expect { create_invalid_comment }.to_not change(question.comments, :count)
      end

      it "Don't create @question.to_json after create question" do
        create_invalid_comment
        expect(PrivatePub).to_not receive(:publish_to).with('/comments', anything)
      end

      it "does not save comment for user in database" do
        expect { create_invalid_comment }.to_not change(@user.comments, :count)
      end
    end
  end

  describe 'POST #create for answers' do
    context 'with valid attributes' do
      let(:subject) { post :create, commentable: 'answers', answer_id: answer.id, comment: attributes_for(:comment), format: :js }

        it "save new comment in database" do
          expect { 
            subject 
            }.to change(answer.comments, :count).by(+1)
        end

        it "save new comment for user in database" do
          expect {
          subject  
          }.to change(@user.comments, :count).by(+1)
        end
          
        it_behaves_like 'publishable', "/comments" 
        
        it "render nothing" do
          subject
          expect(response.body).to eq ""
        end
     end

    context 'with invalid attributes' do
      let(:create_invalid_comment) { post :create, commentable: 'answer', answer_id: answer.id, comment: { body: nil }, format: :js }

      it "does not save comment for answer in database" do
        expect { create_invalid_comment }.to_not change(answer.comments, :count)
      end

      it "Don't create @question.to_json after create question" do
        create_invalid_comment
        expect(PrivatePub).to_not receive(:publish_to).with('/comments', anything)
      end

      it "does not save comment for user in database" do
        expect { create_invalid_comment }.to_not change(@user.comments, :count)
      end
    end
  end


end
