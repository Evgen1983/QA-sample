require 'rails_helper'

feature 'Browse question with answers on it', %q{
  In order to find answer
  As an anyone
  I want to be able to browse question with answers list
} do

  given!(:question) { create(:question) }
  given!(:answers) { create_pair(:answer, question: question) }

  scenario 'Show question' do
   
    visit questions_path
    click_on question.title

    expect(current_path).to eq question_path(question)
    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each do |q|
      expect(page).to have_content(q.body)
    end
  end
end