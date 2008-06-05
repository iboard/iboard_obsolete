require File.dirname(__FILE__) + '/../test_helper'

class GalleriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:galleries)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_gallery
    assert_difference('Gallery.count') do
      post :create, :gallery => { }
    end

    assert_redirected_to gallery_path(assigns(:gallery))
  end

  def test_should_show_gallery
    get :show, :id => galleries(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => galleries(:one).id
    assert_response :success
  end

  def test_should_update_gallery
    put :update, :id => galleries(:one).id, :gallery => { }
    assert_redirected_to gallery_path(assigns(:gallery))
  end

  def test_should_destroy_gallery
    assert_difference('Gallery.count', -1) do
      delete :destroy, :id => galleries(:one).id
    end

    assert_redirected_to galleries_path
  end
end
