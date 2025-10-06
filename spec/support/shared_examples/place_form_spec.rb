require 'rails_helper'

RSpec.shared_examples 'place form' do
  it "shows the form" do
    expect(page).to have_css("form")
  end


  it "has a name field" do
    expect(page).to have_field("place[name]", type: "text")
  end

  it "requires name" do
    expect(page).to have_selector("input[name='place[name]'][required]")
  end

  it "requires name to be at least 3 characters" do
    expect(page).to have_selector("input[name='place[name]'][minlength='3']")
  end

  it "requires name to be at most 255 characters" do
    expect(page).to have_selector("input[name='place[name]'][maxlength='255']")
  end

  it "has a description field" do
    expect(page).to have_field("place[description]", type: "textarea")
  end

  it "requires description to be at most 1000 characters" do
    expect(page).to have_selector("textarea[name='place[description]'][maxlength='1000']")
  end

  describe "coordinates" do
    it "has a longitude field" do
      expect(page).to have_field("place[longitude]", type: "number")
    end

    it "has a latitude field" do
      expect(page).to have_field("place[latitude]", type: "number")
    end

    it "requires latitude" do
      expect(page).to have_selector("input[name='place[latitude]'][required]")
    end

    it "requires longitude" do
      expect(page).to have_selector("input[name='place[longitude]'][required]")
    end

    it "has a latitude input with proper range" do
      latitude_input = find("input[name='place[latitude]']")
      expect(latitude_input["min"]).to eq("-90")
      expect(latitude_input["max"]).to eq("90")
      expect(latitude_input["step"]).to eq("any")
    end

    it "has a longitude input with proper range" do
      longitude_input = find("input[name='place[longitude]']")
      expect(longitude_input["min"]).to eq("-180")
      expect(longitude_input["max"]).to eq("180")
      expect(longitude_input["step"]).to eq("any")
    end

  end

  it "has a submit button" do
    expect(page).to have_css("form input[type='submit']")
  end
end