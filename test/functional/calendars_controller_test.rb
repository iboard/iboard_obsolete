require File.dirname(__FILE__) + '/../test_helper'

class CalendarsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:calendars)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_calendar
    assert_difference('Calendar.count') do
      post :create, :calendar => { }
    end

    assert_redirected_to calendar_path(assigns(:calendar))
  end

  def test_should_show_calendar
    get :show, :id => calendars(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => calendars(:one).id
    assert_response :success
  end

  def test_should_update_calendar
    put :update, :id => calendars(:one).id, :calendar => { }
    assert_redirected_to calendar_path(assigns(:calendar))
  end

  def test_should_destroy_calendar
    assert_difference('Calendar.count', -1) do
      delete :destroy, :id => calendars(:one).id
    end

    assert_redirected_to calendars_path
  end
end
