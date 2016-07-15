require 'acceptance_helper'

feature 'Question editing', %q{
  In order to fix mistake
  As an author of question
  I'd like ot be able to edit my question
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, user: users[0]) }


  scenario 'Unauthenticated user try to edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Question'
  end


  describe 'Author of question' do
    before do
      sign_in(users[0])
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.question' do
        expect(page).to have_link 'Edit Question'
      end
    end

    scenario 'try to edit his question', js: true do
      click_on 'Edit Question'
      within '.question' do
        fill_in 'Edit Title', with: 'edited question Title text text text text text'
        fill_in 'Edit Body', with: 'edited question Body text text text text text'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to_not have_content question.title
        expect(page).to have_content 'edited question Title text text text text text'
        expect(page).to have_content 'edited question Body text text text text text'
        expect(page).to_not have_selector 'textarea#question_body'
      end
    end

    scenario 'try to edit his invalid question', js: true do
      click_on 'Edit Question'
      within '.question' do
        fill_in 'Edit Title', with: ' '
        fill_in 'Edit Body', with: ' '
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content question.title
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_content "Title can't be blank"
        expect(page).to have_selector 'textarea#question_body'
      end
    end

    scenario "try to edit other user's Question" do
      click_on 'Sign out'
      sign_in(users[1])
      visit question_path(question)
      within '.question' do
        expect(page).to_not have_link 'Edit Question'
      end
    end
  end
end