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
  end
end