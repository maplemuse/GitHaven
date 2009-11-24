ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'application'

  map.connect 'login', :controller => 'users', :action => 'login'
  map.connect 'logout', :controller => 'users', :action => 'logout'
  map.connect 'signup', :controller => 'users', :action => 'new'
  map.connect 'preferences', :controller => 'users', :action => 'edit'
 
  map.resources :permissions
  map.resources :sshkeys
  map.resources :repositories
  map.resources :users

  map.connect ':user',
      :controller => 'users',
      :action => 'show'

  map.connect ':user/:repo',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect ':user/:repo/tree',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect ':user/:repo/tree/:branch/:path',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect ':user/:repo/commits',
      :controller => 'repositories',
      :action => 'commits',
      :conditions => { :method => :get }

  map.connect ':user/:repo/commit/:sha1',
      :controller => 'repositories',
      :action => 'commit',
      :conditions => { :method => :get }


  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
