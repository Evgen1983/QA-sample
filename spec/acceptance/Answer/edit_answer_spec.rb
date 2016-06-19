require 'acceptance_helper'

feature 'Answer editing', %q{
  In order to fix mistake
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:users) { create_pair(:user) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:answer) { create(:answer, question: question, user: users[0]) }


  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Answer'
  end


  describe 'Author of answer' do
    before do
      sign_in(users[0])
      visit question_path(question)
    end

    scenario 'sees link to Edit' do
      within '.answers' do
        expect(page).to have_link 'Edit Answer'
      end
    end

    scenario 'try to edit his answer', js: true do
      click_on 'Edit Answer'
      within '.answers' do
        fill_in 'Answer', with: 'edited answer text text text text text'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer text text text text text'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'try to edit his invalid answer', js: true do
      click_on 'Edit Answer'
      within '.answers' do
        fill_in 'Answer', with: ' '
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).to have_selector 'textarea'
      end
    end

    scenario "try to edit other user's Answer" do
      click_on 'Sign out'
      sign_in(users[1])
      visit question_path(question)
      within '.answers' do
        expect(page).to_not have_link 'Edit Answer'
      end
    end
  end
end