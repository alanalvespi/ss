require 'test_helper'

class PlantypestrategyfundsControllerTest < ActionController::TestCase
  setup do
    @plantypestrategyfund = plantypestrategyfunds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plantypestrategyfunds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plantypestrategyfund" do
    assert_difference('Plantypestrategyfunds.count') do
      post :create, plantypestrategyfund: { deposit_plantype_fund_id: @plantypestrategyfund.deposit_plantype_fund_id, market_id: @plantypestrategyfund.market_id, plantypefund_id: @plantypestrategyfund.plantypefund_id, plantypestrategy_id: @plantypestrategyfund.plantypestrategy_id, plantypestrategyfund_id: @plantypestrategyfund.plantypestrategyfund_id }
    end

    assert_redirected_to plantypestrategyfund_path(assigns(:plantypestrategyfund))
  end

  test "should show plantypestrategyfund" do
    get :show, id: @plantypestrategyfund
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plantypestrategyfund
    assert_response :success
  end

  test "should update plantypestrategyfund" do
    put :update, id: @plantypestrategyfund, plantypestrategyfund: { deposit_plantype_fund_id: @plantypestrategyfund.deposit_plantype_fund_id, market_id: @plantypestrategyfund.market_id, plantypefund_id: @plantypestrategyfund.plantypefund_id, plantypestrategy_id: @plantypestrategyfund.plantypestrategy_id, plantypestrategyfund_id: @plantypestrategyfund.plantypestrategyfund_id }
    assert_redirected_to plantypestrategyfund_path(assigns(:plantypestrategyfund))
  end

  test "should destroy plantypestrategyfund" do
    assert_difference('Plantypestrategyfunds.count', -1) do
      delete :destroy, id: @plantypestrategyfund
    end

    assert_redirected_to plantypestrategyfunds_index_path
  end
end
