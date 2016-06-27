require 'acceptance_helper'

feature 'Add files to question', %q{
  In order to illustrate my question
  As an question's author
  I'd like to be able to attach files
} do

  given(:user) { create(:user) }
  
  background do
    sign_in(user)
    visit questions_path
  end

  scenario 'User adds file when asks and then edit question', js: true do
    click_on 'Ask Question'
    fill_in 'Title', with: 'Test question one'
    fill_in 'Body', with: 'text text text text text text text'  
     
    within all(:css, ".nested-fields").first do
      attach_file 'File', "#{Rails.root}/public/robots.txt"
    end
    
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


end