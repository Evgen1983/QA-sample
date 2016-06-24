require 'acceptance_helper'

feature 'Create question', %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask the question
} do

    given(:user) { create(:user)}

    scenario 'Authenticated user create the question' do
     
      sign_in(user)
      visit questions_path
      click_on 'Ask question'
      fill_in 'Title', with: 'Test question one'
      fill_in 'Body', with: 'text text text text text text text'
      click_on 'Create'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question one'
      expect(page).to have_content 'text text text text text text text'

    end

    scenario 'Non-authenticated user try to create question' do
      
      visit questions_path
      click_on 'Ask question'

      expect(page).to have_content 'You need to sign in or sign up before continuing.'

    end

  end  