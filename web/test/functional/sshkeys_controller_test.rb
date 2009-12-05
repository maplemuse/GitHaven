require 'test_helper'

class SshkeysControllerTest < ActionController::TestCase
  fixtures :users
  fixtures :sshkeys

  test 'new' do
    get :new
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end
  test 'new_w_login' do
    get :new, {}, {:user_id => users(:one).id}
    assert_nil flash[:notice]
    assert_not_nil assigns(:sshkey)
    assert_response :success
    assert_template 'new'
  end

  test 'should create sshkey' do
    assert_difference('Sshkey.count', 0) do
      post :create, :sshkey => { }
    end
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end
  test 'create_w_login' do
    assert_difference('Sshkey.count') do
      post :create, {:sshkey => {:name => 'Default', :key => 'x' }}, {:user_id => users(:one).id}
    end

    assert_not_nil flash[:notice]
    assert_redirected_to :controller => 'users', :user => users(:one).username
  end

  test 'edit' do
    get :edit, :id => sshkeys(:one).id
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end
  test 'edit_w_login' do
    get :edit, {:id => sshkeys(:one).id}, {:user_id => users(:one).id}
    assert_response :success
    assert_nil flash[:notice]
    assert_not_nil assigns(:sshkey)
  end

  test 'update' do
    get :update, :id => sshkeys(:one).id
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end
  test 'update_w_login' do
    get :update, {:id => sshkeys(:one).id, :sshkey => {}}, {:user_id => users(:one).id}
    assert_not_nil flash[:notice]
    assert_redirected_to :controller => 'users', :user => users(:one).username
  end

  test 'destroy' do
    assert_difference('Sshkey.count', 0) do
      delete :destroy, :id => sshkeys(:one).id
    end
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end
  test 'destroy_w_login ' do
    assert_difference('Sshkey.count', -1) do
      delete :destroy, {:id => sshkeys(:one).id}, {:user_id => users(:one).id}
    end

    assert_not_nil flash[:notice]
    assert_redirected_to :controller => 'users', :user => users(:one).username
  end
end
