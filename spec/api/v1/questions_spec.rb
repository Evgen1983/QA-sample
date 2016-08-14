require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions", { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_pair(:question) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before { get '/api/v1/questions', format: :json, access_token: access_token.token }

      it_behaves_like "successfully reponsible"

      it 'returns list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      it 'question object contains short_title' do
        expect(response.body).to be_json_eql(question.title.truncate(10).to_json).at_path("questions/0/short_title")
      end

      context 'answers' do
        it 'included in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end  
  end

  describe 'GET /show' do
    let(:question) { create :question }
    let!(:comment) { create :comment, commentable: question }
    let!(:attachment) { create :attachment, attachable: question }

    it_behaves_like "API Authenticable"

    def do_request(options = {})
      get "/api/v1/questions/#{question.id}", { format: :json }.merge(options)
    end

    context 'authorized' do
      let(:access_token) { create :access_token }

      before { get "/api/v1/questions/#{question.id}",
               format: :json, access_token: access_token.token }

      it_behaves_like "successfully reponsible"
      
      it { expect(response.body).to have_json_size(1) }
      
      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          expect(response.body).to be_json_eql(
            question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      context 'comments' do
        
        it 'includes comments list' do
          expect(response.body).to have_json_size(1).at_path('question/comments')
        end

        %w(id content created_at updated_at).each do |attr|
          it "contains #{attr}" do
            expect(response.body).to be_json_eql(
              comment.send(attr.to_sym).to_json).at_path("question/comments/0/#{attr}")
          end
        end
      end

      context 'attachments' do

        it 'includes attachments list' do
          expect(response.body).to have_json_size(1).at_path('question/attachments')
        end
        
         it "contains url" do
          expect(response.body).to be_json_eql(
            attachment.url.to_json).at_path("question/attachments/0/url")
        end
      end
    end
  end
  
  describe 'POST /create' do
    let(:access_token) { create(:access_token) }
    let(:user) { User.find(access_token.resource_owner_id) }

    it_behaves_like "API CreateAuthenticable"

    def do_request(options = {})
      post '/api/v1/questions', { format: :json, question: attributes_for(:question) }.merge(options)
    end

    context 'authorized' do
      context 'with valid attributes' do
        subject { post '/api/v1/questions', format: :json, access_token: access_token.token, question: attributes_for(:question) }
        it 'reponses with 201' do
          subject
          expect(response.status).to eq 201
        end

        it 'creates new question' do
          expect{
           subject
          }.to change(user.questions, :count).by 1
        end
      end

      context 'with invalid attributes' do
        subject { post '/api/v1/questions', format: :json, access_token: access_token.token, question: { body: nil } }

        it 'responses with 422' do
          subject
        expect(response.status).to eq 422
        end

        it 'doesnt create new question' do
          expect{
            subject
          }.to_not change(Question, :count)
        end
      end
    end
  end
end