require 'rails_helper'

describe 'Answers API' do
  let!(:question) { create(:question) }

  describe 'GET /index' do

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}/answers", { format: :json }.merge(options)
    end


    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token }

      it_behaves_like "successfully reponsible"

      it 'returns list of answers' do
        expect(response.body).to have_json_size(3).at_path('answers')
      end

      %w(id body best created_at updated_at question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET /show' do
    let(:answer) { create(:answer) }
    let!(:comment) { create(:comment, commentable: answer) }
    let!(:attachment) { create(:attachment, attachable: answer) }

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/answers/#{answer.id}", { format: :json }.merge(options)
    end


    context 'authorized' do
      let!(:access_token) { create :access_token }

      before { get "/api/v1/answers/#{answer.id}", format: :json, access_token: access_token.token }

      it_behaves_like "successfully reponsible"
     
      it 'return answer object' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body best created_at updated_at question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      context 'comments' do
        it 'includes comments list' do
          expect(response.body).to have_json_size(1).at_path('answer/comments')
        end

        %w(id content created_at updated_at).each do |attr|
          it "comment object contains #{attr}" do
            expect(response.body).to be_json_eql(comment.send(attr.to_sym).to_json).at_path("answer/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do
        it 'includes attachments list' do
          expect(response.body).to have_json_size(1).at_path('answer/attachments')
        end

        it 'attachment object contains url' do
          expect(response.body).to be_json_eql(attachment.url.to_json).at_path('answer/attachments/0/url')
        end
      end
    end
  end

  describe 'POST /create' do
    let(:access_token) { create(:access_token) }
    let(:user) { User.find(access_token.resource_owner_id) }
    let(:question) { create(:question, user: user) }

    it_behaves_like "API CreateAuthenticable"
    def do_request(options = {})
      post "/api/v1/questions/#{question.id}/answers", { format: :json, question: attributes_for(:question) }.merge(options)
    end

    context 'authorized' do
      context 'with valid attributes' do
        subject { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: attributes_for(:answer) }

        it 'reponses with 201' do
          subject
          expect(response.status).to eq 201
        end

        it 'creates new answer' do
          expect{
            subject
          }.to change(user.answers, :count).by 1
        end

        it 'creates new answer' do
          expect{
            subject
          }.to change(question.answers, :count).by 1
        end
      end


      context 'with invalid attributes' do
        subject { post "/api/v1/questions/#{question.id}/answers", format: :json, access_token: access_token.token, answer: { body: nil } }

        it 'responses with 422' do
          subject
          expect(response.status).to eq 422
        end

        it 'doesnt create new answer' do
          expect{
            subject
          }.to_not change(Answer, :count)
        end
      end
    end
  end
end