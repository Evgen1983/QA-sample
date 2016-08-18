require 'rails_helper'

RSpec.describe Question, type: :model do
  subject { build(:question) }

  it_behaves_like 'votable'
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:user_id) }
  it { should validate_length_of(:title).is_at_least(15) }
  it { should validate_length_of(:title).is_at_most(150) } 
  it { should validate_length_of(:body).is_at_least(30) }
  it { should validate_length_of(:body).is_at_most(30000) }
  it { should have_many(:answers).dependent(:destroy)}
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribers).through(:subscriptions) }

  describe '#subscribe_author' do
    it 'adds user to subscribers after create' do
      expect(subject).to receive(:subscribe).with(subject.user)
      subject.save!
    end
  end

  describe '#subscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'adds given user to subscribers' do
      expect{
        question.subscribe(user)
      }.to change(question.subscribers, :count).by 1
    end

    it 'doesnt add user to subscribers if he is already there' do
      expect{
        question.subscribe(question.user)
      }.to_not change(question.subscribers, :count)
    end
  end

  describe '#unsubscribe' do
    let(:user) { create(:user) }
    let(:question) { create(:question) }

    it 'adds given user to subscribers' do
      expect{
        question.unsubscribe(question.user)
      }.to change(question.subscribers, :count).by(-1)
    end

    it 'doesnt add user to subscribers if he is already there' do
      expect{
        question.unsubscribe(user)
      }.to_not change(question.subscribers, :count)
    end
  end
end
