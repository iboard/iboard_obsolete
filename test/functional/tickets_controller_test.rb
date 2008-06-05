require File.dirname(__FILE__) + '/../test_helper'

class TicketsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:tickets)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_ticket
    assert_difference('Ticket.count') do
      post :create, :ticket => { }
    end

    assert_redirected_to ticket_path(assigns(:ticket))
  end

  def test_should_show_ticket
    get :show, :id => tickets(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => tickets(:one).id
    assert_response :success
  end

  def test_should_update_ticket
    put :update, :id => tickets(:one).id, :ticket => { }
    assert_redirected_to ticket_path(assigns(:ticket))
  end

  def test_should_destroy_ticket
    assert_difference('Ticket.count', -1) do
      delete :destroy, :id => tickets(:one).id
    end

    assert_redirected_to tickets_path
  end
end
