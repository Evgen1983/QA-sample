require 'rails_helper'

feature 'Create answer', %q{
  In order to help community
  As an authenticated user
  I want to be able to create answer 
} do
    given(:question) { create(:question) }
    given(:user) { create(:user)}
    

    scenario 'Authenticated user create the answer' do
     
      sign_in(user)
      visit question_path(question)
      expect(page).to have_content 'Answers'
      click_on 'Your Answer'
      fill_in 'Your Answer', with: 'text text text text text text text'
      click_on 'Send'
      within '.answers' do
        expect(page).to have_content 'text text text text text text text'
      end
      expect(current_path).to eq question_path(question)
    end

    scenario 'Non-authenticated user try to create answer' do
      
      visit question_path(question)
      expect(page).to have_content 'You need to sign in or sign up before create answer.'
    end

  end  