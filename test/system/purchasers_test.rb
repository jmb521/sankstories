require "application_system_test_case"

class PurchasersTest < ApplicationSystemTestCase
  setup do
    @purchaser = purchasers(:one)
  end

  test "visiting the index" do
    visit purchasers_url
    assert_selector "h1", text: "Purchasers"
  end

  test "should create purchaser" do
    visit purchasers_url
    click_on "New purchaser"

    fill_in "Email", with: @purchaser.email
    fill_in "First name", with: @purchaser.first_name
    fill_in "Last name", with: @purchaser.last_name
    fill_in "Phone", with: @purchaser.phone
    click_on "Create Purchaser"

    assert_text "Purchaser was successfully created"
    click_on "Back"
  end

  test "should update Purchaser" do
    visit purchaser_url(@purchaser)
    click_on "Edit this purchaser", match: :first

    fill_in "Email", with: @purchaser.email
    fill_in "First name", with: @purchaser.first_name
    fill_in "Last name", with: @purchaser.last_name
    fill_in "Phone", with: @purchaser.phone
    click_on "Update Purchaser"

    assert_text "Purchaser was successfully updated"
    click_on "Back"
  end

  test "should destroy Purchaser" do
    visit purchaser_url(@purchaser)
    click_on "Destroy this purchaser", match: :first

    assert_text "Purchaser was successfully destroyed"
  end
end
