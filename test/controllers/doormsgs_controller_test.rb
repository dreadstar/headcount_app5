require 'test_helper'

class DoormsgsControllerTest < ActionController::TestCase
  setup do
    @doormsg = doormsgs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:doormsgs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create doormsg" do
    assert_difference('Doormsg.count') do
      post :create, doormsg: { counter_state: @doormsg.counter_state, door_id: @doormsg.door_id, ip_addr: @doormsg.ip_addr, msg: @doormsg.msg, sensor_id: @doormsg.sensor_id, tstamp: @doormsg.tstamp }
    end

    assert_redirected_to doormsg_path(assigns(:doormsg))
  end

  test "should show doormsg" do
    get :show, id: @doormsg
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @doormsg
    assert_response :success
  end

  test "should update doormsg" do
    patch :update, id: @doormsg, doormsg: { counter_state: @doormsg.counter_state, door_id: @doormsg.door_id, ip_addr: @doormsg.ip_addr, msg: @doormsg.msg, sensor_id: @doormsg.sensor_id, tstamp: @doormsg.tstamp }
    assert_redirected_to doormsg_path(assigns(:doormsg))
  end

  test "should destroy doormsg" do
    assert_difference('Doormsg.count', -1) do
      delete :destroy, id: @doormsg
    end

    assert_redirected_to doormsgs_path
  end
end
