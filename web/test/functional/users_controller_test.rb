require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  fixtures :users
  fixtures :sshkeys

  test 'get_login' do
    user = users(:one)
    get :login, :username => user.username, :password => 'secret'
    assert_nil session[:user_id]
    assert_nil flash[:notice]
    assert_template 'login'
  end

  test 'login_failure' do
    user = users(:one)
    post :login, :name => user.name, :password => 'incorrect'
    assert_nil session[:user_id]
    assert_not_nil flash[:notice]
    assert_template 'login'
  end

  test 'login_invalid_params' do
    post :login
    assert_nil session[:user_id]

    assert_not_nil flash[:notice]
    assert_template 'login'
  end

  test 'login_success' do
    user = users(:one)
    post :login, :username => user.username, :password => 'secret'
    assert_equal user.id, session[:user_id]
    assert_nil flash[:notice]
    assert_nil session[:original_uri]
    assert_redirected_to :action => 'show', :user => user.username
  end

  test 'login_redirect' do
    user = users(:one)
    post :login, {:username => user.username, :password => 'secret'}, {:original_uri => 'other_page'}
    assert_equal user.id, session[:user_id]
    assert_nil flash[:notice]
    assert_nil session[:original_uri]
    assert_redirected_to 'other_page'
  end


  test 'logout_already_logged_out' do
    get :logout
    assert_nil session[:user_id]
    assert_not_nil flash[:notice]
    assert_not_nil session[:original_uri]
    assert_redirected_to 'login'
  end

  test 'logout' do
    user = users(:one)
    get :logout, {}, {:user_id => users(:one).id}
    assert_nil session[:user_id]
    assert_not_nil flash[:notice]
    assert_nil session[:original_uri]
    assert_redirected_to 'login'
  end



  test 'index' do
    get :index
    assert_redirected_to :action => 'login'
    assert !flash[:notice].empty?
  end

  test 'index_w_login' do
    get :index, { :id => users(:one).id }, {:user_id => users(:one).id}
    assert_response :success
    assert_template 'index'

    assert_not_nil assigns(:users)
    assert_nil flash[:notice]
  end


  test 'show' do
    get :show, :id => users(:one).id
    assert_nil flash[:notice]
    assert_response :success
    assert_template 'show'
    assert_not_nil assigns(:user)
  end


  test 'new' do
    get :new
    assert_response :success
    assert_template 'new'
    assert_nil flash[:notice]
    assert_not_nil assigns(:user)
  end


  test 'create' do
    assert_difference('User.count') do
      post :create, :user => {:username => 'bob', :email => 'a@b.com', :password => 'x'}
    end

    assert !flash[:notice].empty?
    assert_not_nil session[:user_id]
    assert_redirected_to :controller => 'users', :action => 'show', :user => 'bob'
  end

  test 'create_with_sshkey' do
    post :create, :user => {:username => 'bob', :email => 'a@b.com', :password => 'x'}, :sshkey => 'long key...'
    assert !flash[:notice].empty?
    assert_not_nil session[:user_id]
    assert_redirected_to :controller => 'users', :action => 'show', :user => 'bob'
    user = User.find_by_username('bob')
    assert_not_nil user
    assert user.sshkeys.count == 1
  end

  test 'create_invalid_args' do
    post :create, :user => {:username => 'bob', :email => 'm', :password => 'x'}
    assert_not_nil assigns(:user)
    assert_equal 1, assigns(:user).errors.count
    assert_nil flash[:notice]
    assert_nil session[:user_id]
    assert_template 'new'
  end


  test 'edit' do
    get :edit
    assert_not_nil flash[:notice]
    assert_nil session[:user_id]
    assert_redirected_to :action => 'login'
    assert_nil assigns(:user)
  end

  test 'edit_w_user' do
    user = users(:one)
    get :edit, { :id => users(:one).id }, {:user_id => user.id}
    assert_nil flash[:notice]
    assert_response :success
    assert_template 'edit'
    assert_not_nil assigns(:user)
  end


  test 'update' do
    put :update, :id => users(:one).id, :user => { }
    assert_redirected_to :action => 'login'
    assert_not_nil flash[:notice]
  end

  test 'update_w_login' do
    put :update, {:id => users(:one).id, :user => { }}, {:user_id => users(:one).id}
    assert_redirected_to :controller => 'users', :action => 'show', :user => 'UserName'
  end

  test 'update_invalid_params' do
    put :update, {:id => users(:one).id, :user => {:email => "m"}}, {:user_id => users(:one).id}
    assert_not_nil assigns(:user)
    assert_equal 1, assigns(:user).errors.count
    assert_nil flash[:notice]
    assert_response :success
    assert_template 'edit'
  end


  test 'destroy' do
    assert_difference('User.count', 0) do
      delete :destroy, :id => users(:one).id
    end
    assert_redirected_to :action => 'login'
    assert_not_nil flash[:notice]
  end

  test 'destroy_w_login' do
    assert_difference('User.count', -1) do
      delete :destroy, {:id => users(:one).id, :user => { }}, {:user_id => users(:one).id}
    end
    assert_not_nil flash[:notice]
    assert_redirected_to root_url
  end
end
