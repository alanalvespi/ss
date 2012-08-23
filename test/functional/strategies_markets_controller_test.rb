require 'test_helper'

class StrategiesMarketsControllerTest < ActionController::TestCase
  setup do
    @strategies_market = strategies_markets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:strategies_markets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create strategies_market" do
    assert_difference('StrategiesMarkets.count') do
      post :create, strategies_market: { market_id: @strategies_market.market_id, strategy_id: @strategies_market.strategy_id, strategy_market_id: @strategies_market.strategy_market_id }
    end

    assert_redirected_to strategies_market_path(assigns(:strategies_market))
  end

  test "should show strategies_market" do
    get :show, id: @strategies_market
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @strategies_market
    assert_response :success
  end

  test "should update strategies_market" do
    put :update, id: @strategies_market, strategies_market: { market_id: @strategies_market.market_id, strategy_id: @strategies_market.strategy_id, strategy_market_id: @strategies_market.strategy_market_id }
    assert_redirected_to strategies_market_path(assigns(:strategies_market))
  end

  test "should destroy strategies_market" do
    assert_difference('StrategiesMarkets.count', -1) do
      delete :destroy, id: @strategies_market
    end

    assert_redirected_to strategies_markets_index_path
  end
end
