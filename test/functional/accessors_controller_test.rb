require File.dirname(__FILE__) + '/../test_helper'

class AccessorsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:accessors)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_accessor
    assert_difference('Accessor.count') do
      post :create, :accessor => { }
    end

    assert_redirected_to accessor_path(assigns(:accessor))
  end

  def test_should_show_accessor
    get :show, :id => accessors(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => accessors(:one).id
    assert_response :success
  end

  def test_should_update_accessor
    put :update, :id => accessors(:one).id, :accessor => { }
    assert_redirected_to accessor_path(assigns(:accessor))
  end

  def test_should_destroy_accessor
    assert_difference('Accessor.count', -1) do
      delete :destroy, :id => accessors(:one).id
    end

    assert_redirected_to accessors_path
  end
end
