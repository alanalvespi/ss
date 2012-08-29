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
    assert_difference('Policyfund.count') do
      post :create, policyfund: { fund_id: @policyfund.fund_id, last_mod: @policyfund.last_mod, policy_id: @policyfund.policy_id, policyfund_id: @policyfund.policyfund_id, policyfund_value: @policyfund.policyfund_value, reason: @policyfund.reason, state: @policyfund.state }
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
    put :update, id: @policyfund, policyfund: { fund_id: @policyfund.fund_id, last_mod: @policyfund.last_mod, policy_id: @policyfund.policy_id, policyfund_id: @policyfund.policyfund_id, policyfund_value: @policyfund.policyfund_value, reason: @policyfund.reason, state: @policyfund.state }
    assert_redirected_to policyfund_path(assigns(:policyfund))
  end

  test "should destroy policyfund" do
    assert_difference('Policyfund.count', -1) do
      delete :destroy, id: @policyfund
    end

    assert_redirected_to policyfunds_path
  end
end
