require 'rails_helper'

RSpec.describe NewAnswerNoticeJob, type: :job do
  let(:question) { create :question }
  let(:user)     { create :user }

  before { create :subscription, user: user, question: question }

  context "new answer created" do
    let(:answer)   { create :answer, question: question }

    it 'should send notices to subscribers' do

      expect(NewAnswerMailer).to receive(:notice).
                                 with(question.user, answer).
                                 and_call_original
      expect(NewAnswerMailer).to receive(:notice).
                                 with(user, answer).
                                 and_call_original
      NewAnswerNoticeJob.perform_now(answer)
    end
  end

  context "new answer was not created" do
    it 'should not send notices to subscribers' do
      expect(NewAnswerMailer).to_not receive :notice
      NewAnswerNoticeJob.perform_now(nil)
    end
end
end
