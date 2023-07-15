require "test_helper"

class Admin::MakeStatusControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get admin_make_status_update_url
    assert_response :success
  end
end
