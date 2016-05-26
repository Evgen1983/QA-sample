require 'rails_helper'

feature 'User can sign_out', %q{
  In order to browse questions
  As anyone
  I want to sign_out
  } do
    given(:user) { create(:user) }

    scenario 'User sign_out' do
      sign_in(user)
      click_on 'Sign out'

      expect(page).to have_content 'Signed out successfully.'
      
      expect(current_path).to eq root_path
    end
  end