require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:users) { create_pair(:user) }
  let!(:question) { create(:question, user: users[0]) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe "GET #destroy" do
    context "Not Author" do
      it "can't delete attachment" do
        sign_in(users[1])
        expect {
          delete :destroy, id: attachment, format: :js
        }.to_not change(question.attachments, :count)
      end
    end

    context "Author" do
      it "can delete answer" do
        sign_in(users[0])
        attachment
        expect {
          delete :destroy, id: attachment, format: :js
        }.to change(question.attachments, :count).by(-1)
      end
    end
  end
end
