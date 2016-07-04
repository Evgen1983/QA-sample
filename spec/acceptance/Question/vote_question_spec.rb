require 'acceptance_helper'

feature 'User can vote', %q{
  In order to up or down question
  As an Authenticated User
  I'd like to be able to vote
  } do
    given(:users) { create_pair(:user) }
    given!(:question) { create(:question, user: users[0]) }

    scenario 'Authenticated user can vote && reset for question', js: true do
      sign_in(users[1])
      visit question_path(question)

      within "#question-#{ question.id } " do
        expect(page).to have_content 'Raiting for Question:'
      end

      within ".question_votesbuttons" do
        click_on 'Up'

        expect(page).to have_button('Up', disabled: true) 
        expect(page).to have_button('Down', disabled: true)
        expect(page).to have_button('Reset', disabled: false)
      end

      within ".question_votes" do
        expect(page).to have_content '1'
      end

      within ".question_votesbuttons" do
        click_on 'Reset'

       expect(page).to have_button('Up', disabled: false) 
        expect(page).to have_button('Down', disabled: false)
        expect(page).to have_button('Reset', disabled: true)
      end

      within ".question_votes" do
        expect(page).to have_content '0'
      end

      within ".question_votesbuttons" do
        click_on 'Down'

        expect(page).to have_button('Up', disabled: true) 
        expect(page).to have_button('Down', disabled: true)
        expect(page).to have_button('Reset', disabled: false)
      end

      within ".question_votes" do
        expect(page).to have_content '-1'
      end
    end

    scenario 'Authenticated user can not vote for own question', js: true do
      sign_in(users[0])
      visit question_path(question)

      within ".question_votesbuttons" do
        expect(page).to_not have_button 'Up'
        expect(page).to_not have_button 'Down'
        expect(page).to_not have_button 'Reset'
      end
    end


    scenario 'Unauthenticated user can not voting' do
      visit question_path(question)

       within ".question_votesbuttons" do
        expect(page).to_not have_button 'Up'
        expect(page).to_not have_button 'Down'
        expect(page).to_not have_button 'Reset'
      end
    end
end