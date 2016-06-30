require 'acceptance_helper'

feature 'Add files to answer', %q{
  In order to illustrate my answer
  As an answer's author
  I'd like to be able to attach files
} do

  given(:users) { create_pair(:user) }
  given(:question) { create(:question, user: users[0]) }

  background do
    sign_in(users[0])
    visit question_path(question)
    fill_in 'Your Answer', with: 'text text text text text text text'
    
    within all(:css, ".nested-fields").first do
      attach_file 'File', "#{Rails.root}/public/robots.txt"
    end
  end

  scenario 'Author adds files to answer when create and edit it', js: true do

    click_on 'Add Attachment'
    
    within all(:css, ".nested-fields").last do
      attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    end
    click_on 'Send'
    within '.answers' do
      expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
      expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    
      click_on 'Edit Answer'

      click_on 'Add Attachment'

      within all(:css, ".nested-fields").first do
        attach_file 'File', "#{Rails.root}/public/favicon.ico"
       end
    
      click_on 'Add Attachment'
    
      within all(:css, ".nested-fields").last do
        attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      end
      click_on 'Save'
    
    expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/2/rails_helper.rb'
    expect(page).to have_link 'favicon.ico', href: '/uploads/attachment/file/3/favicon.ico'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/attachment/file/4/spec_helper.rb'
    end
  end

  
  scenario 'Author can delete files', js: true do
    click_on 'Send'
   
    within '.answers' do
      expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
      click_on 'Delete File'
      expect(page).to_not have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
    end
  end

  context "Not Author" do
    before do  
      click_on 'Send'
      click_on 'Sign out'
    end
    scenario "and authentificated user can't delete files", js: true do
      sign_in(users[1])
      visit question_path(question)
    
      within ".answers"do
        expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
        expect(page).to_not have_link 'Delete File'
      end
    end
    
    scenario " and not authentificated user can't delete files", js: true do
      visit question_path(question)
    
      within ".answers"do
        expect(page).to have_link 'robots.txt', href: '/uploads/attachment/file/1/robots.txt'
        expect(page).to_not have_link 'Delete File'
      end
    end
  end  

end