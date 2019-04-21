require 'test_helper'

class StoreflavorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @storeflavor = storeflavors(:one)
  end

  test "should get index" do
    get storeflavors_url
    assert_response :success
  end

  test "should get new" do
    get new_storeflavor_url
    assert_response :success
  end

  test "should create storeflavor" do
    assert_difference('Storeflavor.count') do
      post storeflavors_url, params: { storeflavor: { flavor_id: @storeflavor.flavor_id, store_id: @storeflavor.store_id } }
    end

    assert_redirected_to storeflavor_url(Storeflavor.last)
  end

  test "should show storeflavor" do
    get storeflavor_url(@storeflavor)
    assert_response :success
  end

  test "should get edit" do
    get edit_storeflavor_url(@storeflavor)
    assert_response :success
  end

  test "should update storeflavor" do
    patch storeflavor_url(@storeflavor), params: { storeflavor: { flavor_id: @storeflavor.flavor_id, store_id: @storeflavor.store_id } }
    assert_redirected_to storeflavor_url(@storeflavor)
  end

  test "should destroy storeflavor" do
    assert_difference('Storeflavor.count', -1) do
      delete storeflavor_url(@storeflavor)
    end

    assert_redirected_to storeflavors_url
  end
end
