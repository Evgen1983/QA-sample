require 'acceptance_helper'

feature 'Best Answer', %q{
  In order to choose solution
  As an author of answer
  I'd like ot be able to set best answer
} do
  given(:user)     { create_pair(:user) }
  given(:question) { create(:question, user: user[0]) }
  given!(:answer_1) { create(:answer, question: question, user: user[0]) }
  given!(:answer_2) { create(:answer, question: question, user: user[0]) }


  scenario 'Author of question sees link_to Best Answer', js: true do
    sign_in(user[0])
    visit question_path(question)

    within '.answers' do
      expect(page).to have_link 'Accept as the best Answer'
    end
  end

  scenario "Authenticated user but not author of question don't sees link_to ", js: true do
    sign_in(user[1])
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Accept as the best Answer'
    end
  end

  scenario "Best Answer first in the list", js: true do
    sign_in(user[0])
    visit question_path(question)

    within "#answer-#{ answer_1.id }" do
      click_on 'Accept as the best Answer'
      expect(page).to_not have_link 'Accept as the best Answer'
      expect(page).to have_content 'Best Answer'
    end

    within '.answers' do
      expect(page.first('div')[:id]).to eq "answer-#{answer_1.id}"
    end

    within "#answer-#{ answer_2.id }" do
      click_on 'Accept as the best Answer'
      expect(page).to_not have_link 'Accept as the best Answer'
      expect(page).to have_content 'Best Answer'
    end

    within '.answers' do
      expect(page.first('div')[:id]).to eq "answer-#{answer_2.id}"
    end

  end

  scenario "Not authenticated user don't sees link_to Best Answer", js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Accept as the best Answer'
    end
  end
end