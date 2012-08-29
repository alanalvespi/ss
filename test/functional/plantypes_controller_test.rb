require 'test_helper'

class PlantypesControllerTest < ActionController::TestCase
  setup do
    @plantype = plantypes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:plantypes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create plantype" do
    assert_difference('Plantypes.count') do
      post :create, plantype: { company_id: @plantype.company_id, deposit_fund_id: @plantype.deposit_fund_id, last_mod: @plantype.last_mod, plantype_currency: @plantype.plantype_currency, plantype_id: @plantype.plantype_id, plantype_name: @plantype.plantype_name, reason: @plantype.reason, state: @plantype.state }
    end

    assert_redirected_to plantype_path(assigns(:plantype))
  end

  test "should show plantype" do
    get :show, id: @plantype
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @plantype
    assert_response :success
  end

  test "should update plantype" do
    put :update, id: @plantype, plantype: { company_id: @plantype.company_id, deposit_fund_id: @plantype.deposit_fund_id, last_mod: @plantype.last_mod, plantype_currency: @plantype.plantype_currency, plantype_id: @plantype.plantype_id, plantype_name: @plantype.plantype_name, reason: @plantype.reason, state: @plantype.state }
    assert_redirected_to plantype_path(assigns(:plantype))
  end

  test "should destroy plantype" do
    assert_difference('Plantypes.count', -1) do
      delete :destroy, id: @plantype
    end

    assert_redirected_to plantypes_index_path
  end
end
