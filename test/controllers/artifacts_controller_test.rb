require 'test_helper'

class ArtifactsControllerTest < ActionController::TestCase
  setup do
    @artifact = artifacts(:one)
    @user = users(:admin)
    sign_in @user
  end

  test "non-admin users cannot perform any actions on artifacts" do
    sign_out @user
    [:user, :none].each do |user|
      @user = users(:user)
      sign_in @user

      [:index, :new, :show, :edit].each do |action|
        get action if [:index, :new].include?(action)
        get action, id: @artifact if [:show, :edit].include?(action)
        assert_response :redirect, "#{user} should have been redirected on #{action}"
        assert_redirected_to root_path, "#{user} should have been redirected to root_path on #{action}"
        assert_match 'not authorized', flash[:alert], "#{user} should not have been authorized on #{action}"
      end

      post :create, artifact: { description: @artifact.description, name: @artifact.name, order: @artifact.order, side_id: @artifact.side_id, value: @artifact.value }
      assert_response :redirect, "#{user} should have been redirected on :create"
      assert_redirected_to root_path, "#{user} should have been redirected to root_path on :create"
      assert_match 'not authorized', flash[:alert], "#{user} should not have been authorized on :create"

      patch :update, id: @artifact, artifact: { description: @artifact.description, name: @artifact.name, order: @artifact.order, side_id: @artifact.side_id, value: @artifact.value }
      assert_response :redirect, "#{user} should have been redirected on :update"
      assert_redirected_to root_path, "#{user} should have been redirected to root_path on :update"
      assert_match 'not authorized', flash[:alert], "#{user} should not have been authorized on :update"

      delete :destroy, id: @artifact
      assert_response :redirect, "#{user} should have been redirected on :delete"
      assert_redirected_to root_path, "#{user} should have been redirected to root_path on :delete"
      assert_match 'not authorized', flash[:alert], "#{user} should not have been authorized on :delete"
    end
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:artifacts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create artifact" do
    assert_difference('Artifact.count') do
      post :create, artifact: { description: @artifact.description, name: @artifact.name, order: @artifact.order, side_id: @artifact.side_id, value: @artifact.value }
    end

    assert_redirected_to artifact_path(assigns(:artifact))
  end

  test "should show artifact" do
    get :show, id: @artifact
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @artifact
    assert_response :success
  end

  test "should update artifact" do
    patch :update, id: @artifact, artifact: { description: @artifact.description, name: @artifact.name, order: @artifact.order, side_id: @artifact.side_id, value: @artifact.value }
    assert_redirected_to side_path(assigns(:artifact).side)
  end

  test "should destroy artifact" do
    assert_difference('Artifact.count', -1) do
      delete :destroy, id: @artifact
    end

    assert_redirected_to artifacts_path
  end

  test "copy properties" do
    a = artifacts(:two)
    get :copy_props, id: a
    assert_redirected_to artifacts_url
    assert_not_nil a.properties.find_by(name: 'nop')
  end

  test "copy properties does not overwrite existing" do
    a = artifacts(:two)
    get :copy_props, id: a
    assert_redirected_to artifacts_url
    assert_equal a.properties.find_by(name: 'up').value, '10'
  end
end
