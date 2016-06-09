require 'acceptance_helper'

feature 'Delete question', %q{
  In order to clean wrong question
  As an authenticated user
  I want to be able to delete question
} do

	given (:users) { create_pair(:user) }
	given(:question) { create(:question, user: users[0]) }
    
    scenario "Authenticated user try to delete his question" do
      sign_in(users[0])
      question
      visit question_path(question)
      click_on 'Delete Question'

    expect(page).to have_content "Your question successfully destroyed."
    expect(current_path).to eq questions_path
      	
    end

    scenario "Authenticated user try to delete  not his question" do
      sign_in(users[1])
      visit question_path(question)
      expect(page).to_not have_link 'Delete Question'
    end

     scenario " Non-Authenticated user try to delete  not his question" do
      visit question_path(question)
      expect(page).to_not have_link 'Delete Question'
    end

end

