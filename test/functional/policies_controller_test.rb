require 'test_helper'

class PoliciesControllerTest < ActionController::TestCase
  setup do
    @policy = policies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:policies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create policy" do
    assert_difference('Policies.count') do
      post :create, policy: { client_id: @policy.client_id, plantype_id: @policy.plantype_id, policy_amount_on_deposit: @policy.policy_amount_on_deposit, policy_currency: @policy.policy_currency, policy_id: @policy.policy_id, policy_missing: @policy.policy_missing, policy_no_markets_invested: @policy.policy_no_markets_invested, policy_number: @policy.policy_number, policy_single_premium: @policy.policy_single_premium, policy_start: @policy.policy_start, policy_total_invested: @policy.policy_total_invested, policy_value: @policy.policy_value, strategy_id: @policy.strategy_id }
    end

    assert_redirected_to policy_path(assigns(:policy))
  end

  test "should show policy" do
    get :show, id: @policy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @policy
    assert_response :success
  end

  test "should update policy" do
    put :update, id: @policy, policy: { client_id: @policy.client_id, plantype_id: @policy.plantype_id, policy_amount_on_deposit: @policy.policy_amount_on_deposit, policy_currency: @policy.policy_currency, policy_id: @policy.policy_id, policy_missing: @policy.policy_missing, policy_no_markets_invested: @policy.policy_no_markets_invested, policy_number: @policy.policy_number, policy_single_premium: @policy.policy_single_premium, policy_start: @policy.policy_start, policy_total_invested: @policy.policy_total_invested, policy_value: @policy.policy_value, strategy_id: @policy.strategy_id }
    assert_redirected_to policy_path(assigns(:policy))
  end

  test "should destroy policy" do
    assert_difference('Policies.count', -1) do
      delete :destroy, id: @policy
    end

    assert_redirected_to policies_index_path
  end
end
