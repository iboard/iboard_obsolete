require File.dirname(__FILE__) + '/../test_helper'

class CollectorEntriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:collector_entries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_collector_entry
    assert_difference('CollectorEntry.count') do
      post :create, :collector_entry => { }
    end

    assert_redirected_to collector_entry_path(assigns(:collector_entry))
  end

  def test_should_show_collector_entry
    get :show, :id => collector_entries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => collector_entries(:one).id
    assert_response :success
  end

  def test_should_update_collector_entry
    put :update, :id => collector_entries(:one).id, :collector_entry => { }
    assert_redirected_to collector_entry_path(assigns(:collector_entry))
  end

  def test_should_destroy_collector_entry
    assert_difference('CollectorEntry.count', -1) do
      delete :destroy, :id => collector_entries(:one).id
    end

    assert_redirected_to collector_entries_path
  end
end
