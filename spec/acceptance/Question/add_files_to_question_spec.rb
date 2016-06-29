require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:users) { create_pair(:user) }
 

  
  background do
    sign_in(users[0])
    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question one'
    fill_in 'Body', with: 'text text text text text text text'
    within all(:css, ".nested-fields").first do
      attach_file 'File', "#{Rails.root}/public/robots.txt"
    end
  end

  scenario 'Author adds more files when asks and then edit question', js: true do
    click_on 'Add Attachment'
    
    within all(:css, ".nested-fields").last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Create'
    expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'

    click_on 'Edit Question'

    within '.question' do
      click_on 'Add Attachment'

      within all(:css, ".nested-fields").first do
        attach_file 'File', "#{Rails.root}/public/favicon.ico"
       end
    
      click_on 'Add Attachment'
    
      within all(:css, ".nested-fields").last do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on 'Save'
    end
    expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    expect(page).to have_link 'favicon.ico', href: '/uploads/attachment/file/3/favicon.ico'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/4/spec_helper.rb'
  end

  scenario 'Author can delete files', js: true do
    
    click_on 'Create'
    
    within ".question"do
      expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
      click_on 'Delete File'
      expect(page).to_not have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
    end
  end
  
  context "Not Author" do
    before do  
      click_on 'Create'
      click_on 'Sign out'
    end
    scenario "and authentificated user can't delete files", js: true do
      sign_in(users[1])
      visit questions_path
      click_on 'Test question one'
    
      within ".question"do
        expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
        expect(page).to_not have_link 'Delete File'
      end
    end
    
    scenario " and not authentificated user can't delete files", js: true do
      visit questions_path
      click_on 'Test question one'
    
      within ".question"do
        expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
        expect(page).to_not have_link 'Delete File'
      end
    end

  end  

end