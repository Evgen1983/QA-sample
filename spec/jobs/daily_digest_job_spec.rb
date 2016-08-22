require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users) { create_pair(:user, created_at: (Time.now - 48.hours) ) }

  context "yesterdays questions exist" do
    let(:questions) { create_pair(:question, user: users.first,  created_at: (Time.now - 24.hours)) }

    it 'should send daily digest to all users' do
      users.each do |user|
        expect(DailyMailer).to receive(:digest).with(user, questions).and_call_original
      end
      DailyDigestJob.perform_now
    end
  end

  context "there are no yesterdays quesitons" do
    it 'should not send daily digest' do
      expect(DailyMailer).to_not receive(:digest)
      DailyDigestJob.perform_now
    end
  end
end