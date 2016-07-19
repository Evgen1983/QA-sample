require 'acceptance_helper'

feature 'Siging in', %q{
  In order to be able ask questions
  As an user
  I want be able to sign in
 } do
  
  given(:user) { create(:user)}

  scenario "Existing user try to sign in" do
    
    sign_in(user)
    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-existing user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@user.com'
    fill_in 'Password', with: '12345'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

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
  end

  
  scenario 'User try to sign in with invalid Facebook credentials' do
    visit new_user_session_path

    OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
    click_on 'Sign in with Facebook'
    
    expect(page).to have_content 'Could not authenticate you from Facebook'
end
end