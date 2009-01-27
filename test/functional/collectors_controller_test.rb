require File.dirname(__FILE__) + '/../test_helper'

class CollectorsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:collectors)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_collector
    assert_difference('Collector.count') do
      post :create, :collector => { }
    end

    assert_redirected_to collector_path(assigns(:collector))
  end

  def test_should_show_collector
    get :show, :id => collectors(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => collectors(:one).id
    assert_response :success
  end

  def test_should_update_collector
    put :update, :id => collectors(:one).id, :collector => { }
    assert_redirected_to collector_path(assigns(:collector))
  end

  def test_should_destroy_collector
    assert_difference('Collector.count', -1) do
      delete :destroy, :id => collectors(:one).id
    end

    assert_redirected_to collectors_path
  end
end
