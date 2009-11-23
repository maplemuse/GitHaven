ActionController::Routing::Routes.draw do |map|
  map.resources :permissions

  map.resources :sshkeys

  map.connect 'login', :controller => 'users', :action => 'login'
  map.connect 'logout', :controller => 'users', :action => 'logout'
  map.connect 'signup', :controller => 'users', :action => 'new'
  map.connect 'preferences', :controller => 'users', :action => 'edit'
 
  map.resources :repositories
  map.resources :users

  map.connect ':user/',
      :controller => 'users',
      :action => 'show'

  map.connect ':user/:repo',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

end
