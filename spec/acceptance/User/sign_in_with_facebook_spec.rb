require 'acceptance_helper'

feature 'Siging in with Facebook', %q{
  In order to be able ask questions
  As an Facebook user
  I want be able to sign in
 } do
  
   scenario 'User try to sign in with Facebook account' do
    visit new_user_session_path
    expect(page).to have_content 'Sign in with Facebook'
    
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      provider: 'facebook', 
      uid: '123456',
      info: {email: 'user@email.com'} })  
    click_on 'Sign in with Facebook'

    expect(page).to have_content 'Successfully authenticated from Facebook account.'
    expect(page).to have_content 'Sign out'
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question one'
    fill_in 'Body', with: 'text text text text text text text'
    click_on 'Create'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content 'Test question one'
    expect(page).to have_content 'text text text text text text text'
  end

  
  scenario 'User try to sign in with invalid Facebook credentials' do
    visit new_user_session_path

    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_on 'Sign in with Facebook'
    
    expect(page).to have_content 'Could not authenticate you from Facebook'
end
end