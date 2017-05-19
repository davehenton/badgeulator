require 'test_helper'

class SidesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @side = sides(:one)
    @user = users(:admin)
    sign_in @user
  end

  test 'should get index' do
    get sides_url
    assert_response :success
    assert_not_nil assigns(:sides)
  end

  test 'should get new' do
    get new_side_url
    assert_response :success
  end

  test 'should create side' do
    assert_difference('Side.count') do
      post sides_url, params: {
        side: {
          design_id: @side.design_id,
          height: @side.height,
          margin: @side.margin,
          order: @side.order,
          orientation: @side.orientation,
          width: @side.width
        }
      }
    end

    assert_redirected_to side_path(assigns(:side))
  end

  test 'should show side' do
    get side_url(@side)
    assert_response :success
  end

  test 'should get edit' do
    get edit_side_url(@side)
    assert_response :success
  end

  test 'should update side' do
    patch side_url(@side), params: {
      side: {
        design_id: @side.design_id,
        height: @side.height,
        margin: @side.margin,
        order: @side.order,
        orientation: @side.orientation,
        width: @side.width
      }
    }
    assert_redirected_to side_path(assigns(:side))
  end

  test 'should destroy side' do
    assert_difference('Side.count', -1) do
      delete side_url(@side)
    end

    assert_redirected_to sides_path
  end
end
