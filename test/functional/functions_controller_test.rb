require File.dirname(__FILE__) + '/../test_helper'

class FunctionsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:functions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_function
    assert_difference('Function.count') do
      post :create, :function => { }
    end

    assert_redirected_to function_path(assigns(:function))
  end

  def test_should_show_function
    get :show, :id => functions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => functions(:one).id
    assert_response :success
  end

  def test_should_update_function
    put :update, :id => functions(:one).id, :function => { }
    assert_redirected_to function_path(assigns(:function))
  end

  def test_should_destroy_function
    assert_difference('Function.count', -1) do
      delete :destroy, :id => functions(:one).id
    end

    assert_redirected_to functions_path
  end
end
