require 'acceptance_helper'

feature 'Subscribe question', %q{
  In order to looking for question
  As an user
  I want to be able to Subscribe
} do
  
  
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:subscribed_question) { create(:question, user: user) }
  
  context 'authenticated user' do
    before do
      sign_in user
    end

    scenario 'subscribes to question' do
      visit question_path(question)
      click_on 'Subscribe'
      expect(page).to have_content 'Subscribed successfully!'
    end

    scenario 'unsubscribes from question' do
      visit question_path(subscribed_question)
      click_on 'Unsubscribe'
      expect(page).to have_content 'Unsubscribed successfully!'
    end
  end

  context 'nonauthenticated user' do

    scenario ' try subscribes to question' do
      visit question_path(question)
      expect(page).to_not have_link 'Subscribe'
    end

    scenario ' try unsubscribes from question' do
      visit question_path(subscribed_question)
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end