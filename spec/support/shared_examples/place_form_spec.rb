RSpec.shared_examples 'place form' do

  def submit_form
    find("form input[type='submit']").click
  end

  it "shows the form" do
    expect(page).to have_css("form")
  end

  it "has a name field" do
    expect(page).to have_field("place[name]", type: "text")
  end

  it "shows error if name is not present" do
    submit_form
    within "#errors_for_name" do
      expect(page).to have_content(I18n.t("errors.messages.blank"))
    end
  end

  it "shows error if name is too short" do
    page.fill_in("place[name]", with: "ab")
    submit_form
    within "#errors_for_name" do
      expect(page).to have_content(I18n.t("errors.messages.too_short", count: 3))
    end
  end

  it "shows error if name is too long" do
    page.fill_in("place[name]", with: "a" * 260)
    submit_form
    within "#errors_for_name" do
      expect(page).to have_content(I18n.t("errors.messages.too_long", count: 255))
    end
  end

  it "has a description field" do
    expect(page).to have_field("place[description]", type: "textarea")
  end

  it "shows error if description is too long" do
    page.fill_in("place[description]", with: "a" * 1001)
    submit_form
    within "#errors_for_description" do
      expect(page).to have_content(I18n.t("errors.messages.too_long", count: 1000))
    end
  end

  describe "images" do
    it "has an image field" do
      expect(page).to have_field("place[images][]", type: "file")
    end

    it "shows error if image is too large" do
      with_temp_image(size_in_mb: 6) do |path, name, content_type|
        page.attach_file("place[images][]", path)
        submit_form
        within "#errors_for_images" do
          expect(page).to have_content(I18n.t("activerecord.errors.messages.size_range_exceeded", max: 5, actual: 6))
        end
      end
    end

    it "shows error if more than 8 images are attached" do
      with_temp_images(count: 9, size_in_mb: 1, filename: "file") do |paths|
        page.attach_file("place[images][]", paths, make_visible: true)
        submit_form
        within "#errors_for_images" do
          expect(page).to have_content(I18n.t("activerecord.errors.messages.too_many", max: 8))
        end
      end

    end
  end

  describe "coordinates" do
    it "has a longitude field" do
      expect(page).to have_field("place[longitude]", type: "number")
    end

    it "has a latitude field" do
      expect(page).to have_field("place[latitude]", type: "number")
    end

    it "shows error if latitude is not present" do
      submit_form
      within "#errors_for_latitude" do
        expect(page).to have_content(I18n.t("errors.messages.blank"))
      end
    end

    it "shows error if latitude is gt 90" do
      fill_in("place[latitude]", with: "91")
      submit_form
      within "#errors_for_latitude" do
        expect(page).to have_content(I18n.t("errors.messages.less_than_or_equal_to", count: 90))
      end
    end

    it "shows error if latitude is lt -90" do
      fill_in("place[latitude]", with: "-91")
      submit_form
      within "#errors_for_latitude" do
        expect(page).to have_content(I18n.t("errors.messages.greater_than_or_equal_to", count: -90))
      end
    end

    it "shows error if longitude is not present" do
      submit_form
      within "#errors_for_longitude" do
        expect(page).to have_content(I18n.t("errors.messages.blank"))
      end
    end

    it "shows error if longitude is gt 180" do
      fill_in("place[longitude]", with: "181")
      submit_form
      within "#errors_for_longitude" do
        expect(page).to have_content(I18n.t("errors.messages.less_than_or_equal_to", count: 180))
      end
    end
    it "shows error if longitude is lt -180" do
      fill_in("place[longitude]", with: "-181")
      submit_form
      within "#errors_for_longitude" do
        expect(page).to have_content(I18n.t("errors.messages.greater_than_or_equal_to", count: -180))
      end
    end

  end

  it "has a submit button" do
    expect(page).to have_css("form input[type='submit']")
  end

end