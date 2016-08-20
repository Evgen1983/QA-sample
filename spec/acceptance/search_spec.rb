require 'acceptance_helper'


feature 'Can search', %q{
  In order to find information
  As an user
  I'd like to be able to search
} do
  
  given!(:user) { create(:user, email: 'Serching@test.com') }
  given!(:question) { create(:question, title: 'Serching question title', body: 'Serching question body is not too short, because it contains more than 30 characters') }
  given!(:answer) { create(:answer, body: 'Serching answer is not too short, because it contains more than 30 characters') }
  given!(:comment) { create(:comment, content: 'Serching comment', user: user, commentable: question) }


  background do
    index 
    visit root_path
  end

  describe 'User can' do
   
    

    scenario 'search questions', js: true, type: :sphinx do

      select 'questions', from: 'search_type'
      fill_in 'Search for:', with: 'Serching question'
      click_on 'Find'

      expect(page).to have_content('Serching question')
    end

    scenario 'search answers', js: true, type: :sphinx do
      select 'answers', from: 'search_type'
      fill_in 'Search for:', with: 'Serching answer'
      click_on 'Find'

      expect(page).to have_content('Serching answer')
    end
    
    scenario 'search comments', js: true, type: :sphinx do
      
      select 'comments', from: 'search_type'
      fill_in 'Search for:', with: comment.content
      click_on 'Find'
      expect(page).to have_content comment.content
    end

    scenario 'search users', js: true, type: :sphinx do
     
      select 'users', from: 'search_type'
      fill_in 'Search for:', with: 'Serching@test.com'
      click_on 'Find'
      expect(page).to have_content 'serching@test.com'
    end
    
    scenario 'search anything', type: :sphinx do
      select 'all', from: 'search_type'
      fill_in 'Search for:', with: 'Serching'
      click_on 'Find'
 
      expect(page).to have_content('Serching question')
      expect(page).to have_content('Serching answer')
      expect(page).to have_content('Serching comment')
      expect(page).to have_content('serching@test.com')
    end

    scenario ' search nothing', js: true, type: :sphinx do
      select 'all', from: 'search_type'
      fill_in 'Search for:', with: 'Nothing'
      click_on 'Find'
 
      expect(page).to have_content('Unfortunately nothing was found')
    
    end
  end
end