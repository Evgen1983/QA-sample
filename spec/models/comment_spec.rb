require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }
  it { should belong_to :user }
  it { should have_db_index [:commentable_id, :commentable_type] }
  it { should have_db_index :user_id }
  it { should validate_length_of(:content).is_at_most(1000) }
  it { should validate_presence_of :content }
end
