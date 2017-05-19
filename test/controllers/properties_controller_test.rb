require 'test_helper'

class PropertiesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @property = properties(:one)
    @user = users(:admin)
    sign_in @user
  end

  test 'should get index' do
    get properties_url
    assert_response :success
    assert_not_nil assigns(:properties)
  end

  test 'should get new' do
    get new_property_url
    assert_response :success
  end

  test 'should create property' do
    assert_difference('Property.count') do
      post properties_url, params: {
        property: {
          artifact_id: @property.artifact_id,
          name: @property.name,
          value: @property.value
        }
      }
    end

    assert_redirected_to property_path(assigns(:property))
  end

  test 'should show property' do
    get property_url(@property)
    assert_response :success
  end

  test 'should get edit' do
    get edit_property_url(@property)
    assert_response :success
  end

  test 'should update property' do
    patch property_url(@property), params: {
      property: {
        artifact_id: @property.artifact_id,
        name: @property.name,
        value: @property.value
      }
    }
    assert_redirected_to property_path(assigns(:property))
  end

  test 'should destroy property' do
    assert_difference('Property.count', -1) do
      delete property_url(@property)
    end

    assert_redirected_to properties_path
  end
end
