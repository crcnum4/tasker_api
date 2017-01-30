require 'test_helper'

class DevicesControllerTest < ActionController::TestCase
  setup do
    @device = devices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:devices)
  end

  test "should create device" do
    assert_difference('Device.count') do
      post :create, device: { confirmed: @device.confirmed, model: @device.model, name: @device.name, token: @device.token, uuid: @device.uuid }
    end

    assert_response 201
  end

  test "should show device" do
    get :show, id: @device
    assert_response :success
  end

  test "should update device" do
    put :update, id: @device, device: { confirmed: @device.confirmed, model: @device.model, name: @device.name, token: @device.token, uuid: @device.uuid }
    assert_response 204
  end

  test "should destroy device" do
    assert_difference('Device.count', -1) do
      delete :destroy, id: @device
    end

    assert_response 204
  end
end
