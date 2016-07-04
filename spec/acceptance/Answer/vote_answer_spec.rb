require 'acceptance_helper'

feature 'User can vote', %q{
  In order to  to up or down answer
  As an Authenticated User
  I'd like to be able to vote
  } do
    given(:users) { create_pair(:user) }
    given!(:question) { create(:question, user: users[0]) }
    given!(:answer) { create(:answer, question: question, user: users[0]) }

    scenario 'Authenticated users can vote && reset for their favorite answer', js: true do
      sign_in(users[1])
      visit question_path(question)

      within ".answers" do
        expect(page).to have_content 'Raiting for Answer:'
      end

      within ".answer_votesbuttons" do
        click_on 'Up'

        expect(page).to have_button('Up', disabled: true) 
        expect(page).to have_button('Down', disabled: true)
        expect(page).to have_button('Reset', disabled: false)
      end

      within ".answer_votes" do
        expect(page).to have_content '1'
      end

      within ".answer_votesbuttons" do
        click_on 'Reset'

       expect(page).to have_button('Up', disabled: false) 
        expect(page).to have_button('Down', disabled: false)
        expect(page).to have_button('Reset', disabled: true)
      end

      within ".answer_votes" do
        expect(page).to have_content '0'
      end

      within ".answer_votesbuttons" do
        click_on 'Down'

        expect(page).to have_button('Up', disabled: true) 
        expect(page).to have_button('Down', disabled: true)
        expect(page).to have_button('Reset', disabled: false)
      end

      within ".answer_votes" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'Authenticated users can not vote for own answers', js: true do
      sign_in(users[0])
      visit question_path(question)

      within ".answer_votesbuttons" do
        expect(page).to_not have_button 'Up'
        expect(page).to_not have_button 'Down'
        expect(page).to_not have_button 'Reset'
      end
    end


    scenario 'Unauthenticated users can not voting' do
      visit question_path(question)

      within ".answer_votesbuttons" do
        expect(page).to_not have_button 'Up'
        expect(page).to_not have_button 'Down'
        expect(page).to_not have_button 'Reset'
      end
    end
end