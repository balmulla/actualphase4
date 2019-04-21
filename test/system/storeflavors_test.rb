require "application_system_test_case"

class StoreflavorsTest < ApplicationSystemTestCase
  setup do
    @storeflavor = storeflavors(:one)
  end

  test "visiting the index" do
    visit storeflavors_url
    assert_selector "h1", text: "Storeflavors"
  end

  test "creating a Storeflavor" do
    visit storeflavors_url
    click_on "New Storeflavor"

    fill_in "Flavor", with: @storeflavor.flavor_id
    fill_in "Store", with: @storeflavor.store_id
    click_on "Create Storeflavor"

    assert_text "Storeflavor was successfully created"
    click_on "Back"
  end

  test "updating a Storeflavor" do
    visit storeflavors_url
    click_on "Edit", match: :first

    fill_in "Flavor", with: @storeflavor.flavor_id
    fill_in "Store", with: @storeflavor.store_id
    click_on "Update Storeflavor"

    assert_text "Storeflavor was successfully updated"
    click_on "Back"
  end

  test "destroying a Storeflavor" do
    visit storeflavors_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Storeflavor was successfully destroyed"
  end
end
