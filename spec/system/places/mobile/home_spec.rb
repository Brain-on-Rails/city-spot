require 'rails_helper'

RSpec.describe "Home page", type: :system, mobile: true do
  before do
    visit root_path
  end

  it_behaves_like "map", clickable: false


end
