require 'rails_helper'

RSpec.feature "Insurance Documents", type: :feature do
  let(:user)     { FactoryBot.create(:user, activated: true, activated_at: Time.zone.now) }
  let(:property) { FactoryBot.create(:property, user: user) }

  before do
    # Log in user
    visit '/login'

    within('form') do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
    end
    click_button 'Log in'
    expect(page).to have_content 'Your Happy Homes'
  end

  scenario 'Visiting /index' do
    visit "/users/#{user.id}/properties/#{property.id}/insurance_documents"
    expect(page).to have_text("It looks like you haven't uploaded any Insurance Documents for this Property.")
    expect(page).to have_text("Add one with the upload button.")

    click_on "Upload Document"
    within('form') do
      fill_in 'Title', with: "Test Title 1"
    end
    click_button "Submit"
    expect(page).to have_content "Document can't be blank"
    attach_file "Document", "#{Rails.root}/spec/fixtures/insurance_documents/upload_test_file.txt"
    click_button "Submit"

    expect(page).to have_text("Test Title 1")
  end
end
