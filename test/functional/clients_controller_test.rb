require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  setup do
    @client = clients(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:clients)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create client" do
    assert_difference('Client.count') do
      post :create, client: { client_company_address: @client.client_company_address, client_company_address_change: @client.client_company_address_change, client_id: @client.client_id, client_name: @client.client_name, full_address: @client.full_address, last_mod: @client.last_mod, reason: @client.reason, state: @client.state }
    end

    assert_redirected_to client_path(assigns(:client))
  end

  test "should show client" do
    get :show, id: @client
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @client
    assert_response :success
  end

  test "should update client" do
    put :update, id: @client, client: { client_company_address: @client.client_company_address, client_company_address_change: @client.client_company_address_change, client_id: @client.client_id, client_name: @client.client_name, full_address: @client.full_address, last_mod: @client.last_mod, reason: @client.reason, state: @client.state }
    assert_redirected_to client_path(assigns(:client))
  end

  test "should destroy client" do
    assert_difference('Client.count', -1) do
      delete :destroy, id: @client
    end

    assert_redirected_to clients_path
  end
end
