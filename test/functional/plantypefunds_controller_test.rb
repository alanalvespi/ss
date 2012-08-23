require 'test_helper'

class PlantypefundsControllerTest < ActionController::TestCase
  setup do
    @plantypefund = plantypefunds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plantypefunds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plantypefund" do
    assert_difference('Plantypefunds.count') do
      post :create, plantypefund: { company_id: @plantypefund.company_id, fund_currency: @plantypefund.fund_currency, fund_fkey: @plantypefund.fund_fkey, fund_id: @plantypefund.fund_id, fund_identifier: @plantypefund.fund_identifier, fund_isin: @plantypefund.fund_isin, fund_name: @plantypefund.fund_name, fund_type: @plantypefund.fund_type, last_mod: @plantypefund.last_mod, market_id: @plantypefund.market_id, plantype_id: @plantypefund.plantype_id, reason: @plantypefund.reason, state: @plantypefund.state }
    end

    assert_redirected_to plantypefund_path(assigns(:plantypefund))
  end

  test "should show plantypefund" do
    get :show, id: @plantypefund
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plantypefund
    assert_response :success
  end

  test "should update plantypefund" do
    put :update, id: @plantypefund, plantypefund: { company_id: @plantypefund.company_id, fund_currency: @plantypefund.fund_currency, fund_fkey: @plantypefund.fund_fkey, fund_id: @plantypefund.fund_id, fund_identifier: @plantypefund.fund_identifier, fund_isin: @plantypefund.fund_isin, fund_name: @plantypefund.fund_name, fund_type: @plantypefund.fund_type, last_mod: @plantypefund.last_mod, market_id: @plantypefund.market_id, plantype_id: @plantypefund.plantype_id, reason: @plantypefund.reason, state: @plantypefund.state }
    assert_redirected_to plantypefund_path(assigns(:plantypefund))
  end

  test "should destroy plantypefund" do
    assert_difference('Plantypefunds.count', -1) do
      delete :destroy, id: @plantypefund
    end

    assert_redirected_to plantypefunds_index_path
  end
end
