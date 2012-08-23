require 'test_helper'

class PolicyfundsControllerTest < ActionController::TestCase
  setup do
    @policyfund = policyfunds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:policyfunds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create policyfund" do
    assert_difference('Policyfunds.count') do
      post :create, policyfund: { fund_id: @policyfund.fund_id, policy_id: @policyfund.policy_id, policyfund_id: @policyfund.policyfund_id, policyfund_value: @policyfund.policyfund_value }
    end

    assert_redirected_to policyfund_path(assigns(:policyfund))
  end

  test "should show policyfund" do
    get :show, id: @policyfund
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @policyfund
    assert_response :success
  end

  test "should update policyfund" do
    put :update, id: @policyfund, policyfund: { fund_id: @policyfund.fund_id, policy_id: @policyfund.policy_id, policyfund_id: @policyfund.policyfund_id, policyfund_value: @policyfund.policyfund_value }
    assert_redirected_to policyfund_path(assigns(:policyfund))
  end

  test "should destroy policyfund" do
    assert_difference('Policyfunds.count', -1) do
      delete :destroy, id: @policyfund
    end

    assert_redirected_to policyfunds_index_path
  end
end
