require 'test_helper'

class TradeCenterControllerTest < ActionController::TestCase
  test "should get all_posted_shifts" do
    get :all_posted_shifts
    assert_response :success
  end

  test "should get pick_up_shift" do
    get :pick_up_shift
    assert_response :success
  end

end
