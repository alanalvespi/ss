require 'test_helper'

class StrategiesControllerTest < ActionController::TestCase
  setup do
    @strategy = strategies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:strategies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create strategy" do
    assert_difference('Strategies.count') do
      post :create, strategy: { strategy_filter: @strategy.strategy_filter, strategy_id: @strategy.strategy_id, strategy_initial_switch_percentage: @strategy.strategy_initial_switch_percentage, strategy_name: @strategy.strategy_name, strategy_trigger_in: @strategy.strategy_trigger_in, strategy_trigger_out: @strategy.strategy_trigger_out }
    end

    assert_redirected_to strategy_path(assigns(:strategy))
  end

  test "should show strategy" do
    get :show, id: @strategy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @strategy
    assert_response :success
  end

  test "should update strategy" do
    put :update, id: @strategy, strategy: { strategy_filter: @strategy.strategy_filter, strategy_id: @strategy.strategy_id, strategy_initial_switch_percentage: @strategy.strategy_initial_switch_percentage, strategy_name: @strategy.strategy_name, strategy_trigger_in: @strategy.strategy_trigger_in, strategy_trigger_out: @strategy.strategy_trigger_out }
    assert_redirected_to strategy_path(assigns(:strategy))
  end

  test "should destroy strategy" do
    assert_difference('Strategies.count', -1) do
      delete :destroy, id: @strategy
    end

    assert_redirected_to strategies_index_path
  end
end
