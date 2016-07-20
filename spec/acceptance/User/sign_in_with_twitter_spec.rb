require 'acceptance_helper'

feature 'Siging in with Twitter', %q{
  In order to be able ask questions
  As an Twitter user
  I want be able to sign in
 } do
  
  context 'User try to sign in with Twitter account' do
    before do
      visit new_user_session_path
      expect(page).to have_content 'Sign in with Twitter'
      mock_auth_sucsess(:twitter) 
      click_on 'Sign in with Twitter'
    end
    
    scenario' Successfully authenticated' do
    
      fill_in 'auth_info_email', with: 'test@test.com'
      click_on 'Submit'
      expect(page).to have_content 'Successfully authenticated from Twitter account'

      click_on 'Sign out'
      click_on 'Sign in'
      click_on 'Sign in with Twitter'

      expect(page).to have_content 'Successfully authenticated from Twitter account.'
      expect(page).to have_content 'Sign out'
      click_on 'Ask Question'
      fill_in 'Title', with: 'Test question one'
      fill_in 'Body', with: 'text text text text text text text'
      click_on 'Create'

      expect(page).to have_content 'Question was successfully created.'
      expect(page).to have_content 'Test question one'
      expect(page).to have_content 'text text text text text text text'
    end

    scenario 'whithout email confirmation' do
      click_on 'Submit'
      expect(page).to have_content 'Email is required to compete sign up'
    end
  end

  scenario 'with invalid Twitter credentials' do
    visit new_user_session_path
    mock_auth_invalid(:twitter) 
    click_on 'Sign in with Twitter'
    expect(page).to have_content 'Could not authenticate you from Twitter'
  end
end