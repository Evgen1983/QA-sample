require 'acceptance_helper'

feature 'user can comment answer', %q{
  In order to illustrate my answer
  As an authenticated user
  I'd like to add comment for answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Signed in User' do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'add comment', js: true do
      within '.answer_comment_form' do
        fill_in 'Add Comment', with: 'Test'
        click_on 'Submit'
      end

      within '.answer_comments' do
        expect(page).to have_content 'Test'
      end
      
    end


    scenario 'add invalid comment', js: true do
      within '.answer_comment_form' do
        fill_in 'Add Comment', with: nil
        click_on 'Submit'
        expect(page).to have_content "Content can't be blank"
      end     
    end
  end
   
  describe 'Not authenticated user' do
    before do
      visit question_path(question)
    end

    scenario 'Do not add comment', js: true do
      within '.answer_comment_form' do
        expect(page).to_not have_selector 'textarea#comment_content'
        expect(page).to have_content 'You need to sign in or sign up before create comment'
      end
    end
  end

end