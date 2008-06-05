require File.dirname(__FILE__) + '/../test_helper'

class PostingsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:postings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_posting
    assert_difference('Posting.count') do
      post :create, :posting => { }
    end

    assert_redirected_to posting_path(assigns(:posting))
  end

  def test_should_show_posting
    get :show, :id => postings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => postings(:one).id
    assert_response :success
  end

  def test_should_update_posting
    put :update, :id => postings(:one).id, :posting => { }
    assert_redirected_to posting_path(assigns(:posting))
  end

  def test_should_destroy_posting
    assert_difference('Posting.count', -1) do
      delete :destroy, :id => postings(:one).id
    end

    assert_redirected_to postings_path
  end
end
