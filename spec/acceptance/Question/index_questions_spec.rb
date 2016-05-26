require 'rails_helper'

feature 'User can browse index of questions', %q{
	In order to get necessary question
	As an any User
	I want to be able to browse list of questions, choose question and click on it
 }do
  
  given!(:questions) { create_list(:question, 2) }

  scenario 'Any user can choose any question' do
    visit questions_path
    expect(current_path).to eq questions_path
    expect(page).to have_content 'All Questions'
    questions.each do |q|
      expect(page).to have_content(q.title)
      click_on (q.title)
      expect(page).to have_content(q.body)
      click_on 'Back'
    end
  end   
end
