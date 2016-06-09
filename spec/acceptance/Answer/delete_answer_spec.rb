require 'acceptance_helper'

feature 'Delete answer', %q{
  In order to clean wrong answer
  As an authenticated user
  I want to be able to delete answer
} do
  given (:users) { create_pair(:user) }
  given(:question) { create(:question, user: users[0]) }
  given(:answer) { create(:answer, question: question, user: users[0]) }

  scenario 'Authenticated user try delete his answer' do
    sign_in(users[0])
    answer
    visit question_path(question)
    click_on 'Delete Answer'

    expect(page).to have_content 'Your answer successfully destroyed.'
    expect(page).to_not have_content answer.body
    expect(current_path).to eq question_path(question)
  end

  scenario "Authenticated user try delete not his answer" do
    sign_in(users[1])
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end

  scenario 'Non-authenticated user try delete answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end
end