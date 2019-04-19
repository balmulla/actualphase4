require "application_system_test_case"

class ShiftjobsTest < ApplicationSystemTestCase
  setup do
    @shiftjob = shiftjobs(:one)
  end

  test "visiting the index" do
    visit shiftjobs_url
    assert_selector "h1", text: "Shiftjobs"
  end

  test "creating a Shiftjob" do
    visit shiftjobs_url
    click_on "New Shiftjob"

    fill_in "Job", with: @shiftjob.job_id
    fill_in "Shift", with: @shiftjob.shift_id
    click_on "Create Shiftjob"

    assert_text "Shiftjob was successfully created"
    click_on "Back"
  end

  test "updating a Shiftjob" do
    visit shiftjobs_url
    click_on "Edit", match: :first

    fill_in "Job", with: @shiftjob.job_id
    fill_in "Shift", with: @shiftjob.shift_id
    click_on "Update Shiftjob"

    assert_text "Shiftjob was successfully updated"
    click_on "Back"
  end

  test "destroying a Shiftjob" do
    visit shiftjobs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Shiftjob was successfully destroyed"
  end
end
