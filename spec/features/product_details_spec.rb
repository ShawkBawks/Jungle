require 'rails_helper'

RSpec.feature "View the Product Details", type: :feature, js: true do
  #SETUP
  before :each do
    @category = Category.create! name: 'Apparel'
    
    10.times do |n|
      @category.products.create!(
        name: Faker::Hipster.sentence(3),
        description: Faker::Hipster.paragraph(4),
        image: open_asset('apparel1.jpg'),
        quantity: 10,
        price: 64.99
      )
    end
  end
  
  scenario "They see a products details" do
    # ACT
    visit root_path
    click_link("Details", match: :first)
    
    # DEBUG / VERIFY
    
    expect(page).to have_css 'section.products-show', count: 1
    save_screenshot
  end
end