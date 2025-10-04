require 'rails_helper'

RSpec.shared_examples 'place form' do
  it "shows the form" do
    expect(page).to have_css("form")
  end

  it "has a longitude field" do
    expect(page).to have_field("place[longitude]")
  end

  it "has a latitude field" do
    expect(page).to have_field("place[latitude]")
  end

  it "has a submit button" do
    expect(page).to have_css("form input[type='submit']")
  end
end