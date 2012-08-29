require 'test_helper'

class MarketsControllerTest < ActionController::TestCase
  setup do
    @market = markets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:markets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create market" do
    assert_difference('Market.count') do
      post :create, market: { last_mod: @market.last_mod, market_change_from_ref: @market.market_change_from_ref, market_change_from_switch: @market.market_change_from_switch, market_currency: @market.market_currency, market_current_date: @market.market_current_date, market_current_price: @market.market_current_price, market_current_process_date: @market.market_current_process_date, market_dailychange: @market.market_dailychange, market_id: @market.market_id, market_in: @market.market_in, market_last_switch_date: @market.market_last_switch_date, market_last_switch_price: @market.market_last_switch_price, market_msci_name: @market.market_msci_name, market_name: @market.market_name, market_override: @market.market_override, market_reference_date: @market.market_reference_date, market_reference_price: @market.market_reference_price, market_switch: @market.market_switch, msci_index_code: @market.msci_index_code, query_name: @market.query_name, query_section: @market.query_section, reason: @market.reason, state: @market.state }
    end

    assert_redirected_to market_path(assigns(:market))
  end

  test "should show market" do
    get :show, id: @market
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @market
    assert_response :success
  end

  test "should update market" do
    put :update, id: @market, market: { last_mod: @market.last_mod, market_change_from_ref: @market.market_change_from_ref, market_change_from_switch: @market.market_change_from_switch, market_currency: @market.market_currency, market_current_date: @market.market_current_date, market_current_price: @market.market_current_price, market_current_process_date: @market.market_current_process_date, market_dailychange: @market.market_dailychange, market_id: @market.market_id, market_in: @market.market_in, market_last_switch_date: @market.market_last_switch_date, market_last_switch_price: @market.market_last_switch_price, market_msci_name: @market.market_msci_name, market_name: @market.market_name, market_override: @market.market_override, market_reference_date: @market.market_reference_date, market_reference_price: @market.market_reference_price, market_switch: @market.market_switch, msci_index_code: @market.msci_index_code, query_name: @market.query_name, query_section: @market.query_section, reason: @market.reason, state: @market.state }
    assert_redirected_to market_path(assigns(:market))
  end

  test "should destroy market" do
    assert_difference('Market.count', -1) do
      delete :destroy, id: @market
    end

    assert_redirected_to markets_path
  end
end
