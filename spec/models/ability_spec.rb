require 'rails_helper'

describe Ability do
  subject(:ability) { Ability.new(user) }

  describe 'for quest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true}

    it { should be_able_to :menage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }
    let(:question) { create(:question) }
    let(:own_question) { create(:question, user: user) }
    let(:answer) { create(:answer) }
    let(:own_answer) { create(:answer, user: user) }
    let(:answer_own_question)  { create(:answer, question: own_question, user: user) }
   

    #don't admin capability
    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    context 'question' do
      #read
      it { should be_able_to :read, Question }
      #create
      it { should be_able_to :create, Question }
      #update
      it { should be_able_to :update, create(:question, user: user), user: user }
      it { should_not be_able_to :update, create(:question, user: other), user: user }
      #vote
      it { should be_able_to :vote_up, question, user: user }
      it { should be_able_to :vote_down, question, user: user }
      it { should be_able_to :vote_cancel, question, user: user }

      it { should_not be_able_to :vote_up, own_question, user: user }
      it { should_not be_able_to :vote_down, own_question, user: user }
      it { should_not be_able_to :vote_cancel, own_question, user: user }
      #destroy
      it { should be_able_to :destroy, own_question, user: user }

      it { should_not be_able_to :destroy, question, user: user }
    end
    
    context 'answer' do
      #read
      it { should be_able_to :read, Answer }
      #create
      it { should be_able_to :create, Answer }
      #update
      it { should be_able_to :update, create(:answer, user: user), user: user }

      it { should_not be_able_to :update, create(:answer, user: other), user: user }
      #set_best_answer
      it { should be_able_to :best_answer, answer_own_question, user: user }

      it { should_not be_able_to :best_answer, own_answer, user: user }
      #vote
      it { should be_able_to :vote_up, answer, user: user }
      it { should be_able_to :vote_down, answer, user: user }
      it { should be_able_to :vote_cancel, answer, user: user }

      it { should_not be_able_to :vote_up, own_answer, user: user }
      it { should_not be_able_to :vote_down, own_answer, user: user }
      it { should_not be_able_to :vote_cancel, own_answer, user: user }
      #destroy
      it { should be_able_to :destroy, own_answer, user: user }

      it { should_not be_able_to :destroy, answer, user: user }
    end

    context 'for comment' do
      #create
      it { should be_able_to :create, Comment }
    end

    context 'for attachment' do
      context 'to question' do
        let(:attachment) { create(:attachment, attachable: question) }
        let(:own_attachment) { create(:attachment, attachable: own_question) }
        #destroy
        it { should be_able_to :destroy, own_attachment, user: user }

        it { should_not be_able_to :destroy, attachment, user: user }
      end

      context 'to answer' do
        let(:attachment) { create(:attachment, attachable: answer) }
        let(:own_attachment) { create(:attachment, attachable: own_answer) }
        #destroy
        it { should be_able_to :destroy, own_attachment, user: user }

        it { should_not be_able_to :destroy, attachment, user: user }
      end
    end
  end
end