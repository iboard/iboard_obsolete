require File.dirname(__FILE__) + '/../test_helper'

class DivTagsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:div_tags)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_div_tag
    assert_difference('DivTag.count') do
      post :create, :div_tag => { }
    end

    assert_redirected_to div_tag_path(assigns(:div_tag))
  end

  def test_should_show_div_tag
    get :show, :id => div_tags(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => div_tags(:one).id
    assert_response :success
  end

  def test_should_update_div_tag
    put :update, :id => div_tags(:one).id, :div_tag => { }
    assert_redirected_to div_tag_path(assigns(:div_tag))
  end

  def test_should_destroy_div_tag
    assert_difference('DivTag.count', -1) do
      delete :destroy, :id => div_tags(:one).id
    end

    assert_redirected_to div_tags_path
  end
end
