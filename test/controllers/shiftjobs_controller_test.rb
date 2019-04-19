require 'test_helper'

class ShiftjobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @shiftjob = shiftjobs(:one)
  end

  test "should get index" do
    get shiftjobs_url
    assert_response :success
  end

  test "should get new" do
    get new_shiftjob_url
    assert_response :success
  end

  test "should create shiftjob" do
    assert_difference('Shiftjob.count') do
      post shiftjobs_url, params: { shiftjob: { job_id: @shiftjob.job_id, shift_id: @shiftjob.shift_id } }
    end

    assert_redirected_to shiftjob_url(Shiftjob.last)
  end

  test "should show shiftjob" do
    get shiftjob_url(@shiftjob)
    assert_response :success
  end

  test "should get edit" do
    get edit_shiftjob_url(@shiftjob)
    assert_response :success
  end

  test "should update shiftjob" do
    patch shiftjob_url(@shiftjob), params: { shiftjob: { job_id: @shiftjob.job_id, shift_id: @shiftjob.shift_id } }
    assert_redirected_to shiftjob_url(@shiftjob)
  end

  test "should destroy shiftjob" do
    assert_difference('Shiftjob.count', -1) do
      delete shiftjob_url(@shiftjob)
    end

    assert_redirected_to shiftjobs_url
  end
end
