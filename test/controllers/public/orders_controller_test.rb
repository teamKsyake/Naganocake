require "test_helper"

class Public::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_orders_new_url
    assert_response :success
  end

  test "should get check" do
    get public_orders_check_url
    assert_response :success
  end

  test "should get complete_order" do
    get public_orders_complete_order_url
    assert_response :success
  end
end
