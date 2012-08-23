require 'test_helper'

class PlantypeStrategiesControllerTest < ActionController::TestCase
  setup do
    @plantype_strategy = plantype_strategies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plantype_strategies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plantype_strategy" do
    assert_difference('PlantypeStrategy.count') do
      post :create, plantype_strategy: { deposit_fund_id: @plantype_strategy.deposit_fund_id, plantype_id: @plantype_strategy.plantype_id, plantype_strategy: @plantype_strategy.plantype_strategy, plantypestrategyFund_id: @plantype_strategy.plantypestrategyFund_id, strategy_id: @plantype_strategy.strategy_id }
    end

    assert_redirected_to plantype_strategy_path(assigns(:plantype_strategy))
  end

  test "should show plantype_strategy" do
    get :show, id: @plantype_strategy
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plantype_strategy
    assert_response :success
  end

  test "should update plantype_strategy" do
    put :update, id: @plantype_strategy, plantype_strategy: { deposit_fund_id: @plantype_strategy.deposit_fund_id, plantype_id: @plantype_strategy.plantype_id, plantype_strategy: @plantype_strategy.plantype_strategy, plantypestrategyFund_id: @plantype_strategy.plantypestrategyFund_id, strategy_id: @plantype_strategy.strategy_id }
    assert_redirected_to plantype_strategy_path(assigns(:plantype_strategy))
  end

  test "should destroy plantype_strategy" do
    assert_difference('PlantypeStrategy.count', -1) do
      delete :destroy, id: @plantype_strategy
    end

    assert_redirected_to plantype_strategies_path
  end
end
