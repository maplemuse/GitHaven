require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  fixtures :users
  fixtures :sshkeys
  fixtures :repositories
  fixtures :permissions

  test 'new' do
    get :new
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end

  test 'new_w_login' do
    get :new, {}, {:user_id => users(:one).id}
    assert_nil flash[:notice]
    assert_not_nil assigns(:repository)
    assert_response :success
    assert_template 'new'
  end


  test 'create' do
    assert_difference('Repository.count', 0) do
      post :create, :repository => { }
    end
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end

  test 'create_w_login' do
    assert_difference('Repository.count') do
      post :create, {:repository => {:name => 'test' }}, {:user_id => users(:one).id}
    end
    assert_not_nil flash[:notice]
    assert_redirected_to \
        :controller => 'repositories',
        :user => users(:one).username,
        :repo => 'test'
  end

  test 'create_invalid_args' do
    assert_difference('Repository.count', 0) do
      post :create, {:repository => {}}, {:user_id => users(:one).id}
    end
    assert_not_nil assigns(:repository)
    assert_equal 1, assigns(:repository).errors.count
    assert_nil flash[:notice]
    assert_template 'new'
  end


  test 'index' do
    get :index
    assert_nil flash[:notice]
    assert_response :success
    assert_template 'index'
    assert_not_nil assigns(:repositories)
  end


  test 'show' do
    get :show, :id => repositories(:one).id
    assert_nil flash[:notice]
    assert_not_nil assigns(:repository)
    assert_not_nil assigns(:owner)
    assert_not_nil assigns(:branch)
    assert_response :success
    assert_template 'show'
  end


  test 'edit' do
    get :edit, :id => repositories(:one).id
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end

  test 'edit_w_login' do
    get :edit, {:id => repositories(:one).id}, {:user_id => users(:one).id}
    assert_nil flash[:notice]
    assert_not_nil assigns(:repository)
    assert_response :success
    assert_template 'edit'
  end

  test 'edit_w_bad_login' do
    put :edit, {:id => repositories(:one).id, :repository => { }}, {:user_id => users(:two).id}
    assert_not_nil flash[:notice]
    assert_redirected_to root_path
    assert_nil assigns(:repository)
  end


  test 'update' do
    put :update, :id => repositories(:one).id, :repository => { }
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end

  test 'update_w_login' do
    put :update, {:id => repositories(:one).id, :repository => { }}, {:user_id => users(:one).id}
    assert_not_nil flash[:notice]
    assert_redirected_to \
        :controller => 'repositories',
        :user => users(:one).username,
        :repo => 'MyString'
    assert_not_nil assigns(:repository)
  end

  test 'update_w_bad_login' do
    put :update, {:id => repositories(:one).id, :repository => { }}, {:user_id => users(:two).id}
    assert_not_nil flash[:notice]
    assert_redirected_to root_path
    assert_nil assigns(:repository)
  end

  test 'update_bad_args_w_repo' do
    # todo
  end


  test 'destroy' do
    assert_difference('Repository.count', 0) do
      delete :destroy, :id => repositories(:one).id
    end
    assert_not_nil flash[:notice]
    assert_redirected_to 'login'
  end

  test 'destroy_w_login' do
    assert_difference('Repository.count', -1) do
      delete :destroy, {:id => repositories(:one).id}, {:user_id => users(:one).id}
    end

    assert_not_nil flash[:notice]
    assert_redirected_to :controller => 'users', :user => users(:one).username
  end

  test 'destroy_w_bad_login' do
    put :destroy, {:id => repositories(:one).id, :repository => { }}, {:user_id => users(:two).id}
    assert_not_nil flash[:notice]
    assert_nil assigns(:repository)
    assert_redirected_to root_path
  end
end
