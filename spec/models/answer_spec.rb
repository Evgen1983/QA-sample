require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:question) }
  it { should validate_length_of(:body).is_at_least(30) }
  it { should validate_length_of(:body).is_at_most(30000) }
  it { should belong_to(:question) }
  it { should have_db_index(:question_id) }
  it { should have_many(:attachments).dependent(:destroy) }
  it { should accept_nested_attributes_for(:attachments) }
end
