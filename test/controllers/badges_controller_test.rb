require 'test_helper'

class BadgesControllerTest < ActionController::TestCase
  setup do
    @badge = badges(:one)
    @user = users(:user)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:badges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create badge" do
    assert_difference('Badge.count') do
      post :create, badge: { department: @badge.department, employee_id: @badge.employee_id, first_name: @badge.first_name, last_name: @badge.last_name, title: @badge.title }
    end

    assert_redirected_to camera_badge_path(assigns(:badge))
  end

  test "should not create empty badge" do
    assert_no_difference('Badge.count') do
      post :create, badge: { department: 'huzzah' }
    end
    assert_template :new
  end

  test "should show badge" do
    get :show, id: @badge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @badge
    assert_response :success
  end

  test "should update badge" do
    patch :update, id: @badge, badge: { department: @badge.department, employee_id: @badge.employee_id, name: @badge.name, picture: @badge.picture, title: @badge.title }
    assert_redirected_to badge_path(assigns(:badge))
  end

  test "should destroy badge" do
    assert_difference('Badge.count', -1) do
      delete :destroy, id: @badge
    end

    assert_redirected_to badges_path
  end

  test "should generate badge" do
    get :generate, id: @badge
    assert_redirected_to badge_path(@badge)
    assert_match "been generated", flash[:notice]
  end
end
