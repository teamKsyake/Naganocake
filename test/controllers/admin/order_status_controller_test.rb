require "test_helper"

class Admin::OrderStatusControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get admin_order_status_update_url
    assert_response :success
  end
end
