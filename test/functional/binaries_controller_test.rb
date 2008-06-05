require File.dirname(__FILE__) + '/../test_helper'

class BinariesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:binaries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_binary
    assert_difference('Binary.count') do
      post :create, :binary => { }
    end

    assert_redirected_to binary_path(assigns(:binary))
  end

  def test_should_show_binary
    get :show, :id => binaries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => binaries(:one).id
    assert_response :success
  end

  def test_should_update_binary
    put :update, :id => binaries(:one).id, :binary => { }
    assert_redirected_to binary_path(assigns(:binary))
  end

  def test_should_destroy_binary
    assert_difference('Binary.count', -1) do
      delete :destroy, :id => binaries(:one).id
    end

    assert_redirected_to binaries_path
  end
end
