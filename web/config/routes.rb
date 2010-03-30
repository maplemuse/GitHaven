ActionController::Routing::Routes.draw do |map|
  # Root
  map.root :controller => 'application'

  # Named Routes
  map.connect 'login',       :controller => 'users', :action => 'login'
  map.connect 'logout',      :controller => 'users', :action => 'logout'
  map.connect 'signup',      :controller => 'users', :action => 'new'
  map.connect 'preferences', :controller => 'users', :action => 'edit'


  map.connect 'tags/:tag',
      :controller => 'tags',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect 'tags/:action/:repo',
      :controller => 'tags',
      :conditions => { :method => :get }

  # RESTful Routes
  map.resources :users
  map.resources :sshkeys
  map.resources :repositories
  map.resources :permissions
  map.resources :tags

  map.connect 'permissions/:action/:repo',
      :controller => 'permissions',
      :conditions => { :method => :get }

  map.connect ':user',
      :controller => 'users',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect ':user/:repo',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect ':user/:repo/tree',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get }

  map.connect ':user/:repo/tree/:branch',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get },
      :requirements => {:branch => /[^\/]*/ }

  map.connect ':user/:repo/tree/:branch/*path',
      :controller => 'repositories',
      :action => 'show',
      :conditions => { :method => :get },
      :requirements => {:branch => /[^\/]*/ }

  map.connect ':user/:repo/raw/:branch/*path',
      :controller => 'repositories',
      :action => 'raw',
      :conditions => { :method => :get },
      :requirements => {:branch => /[^\/]*/ }

  map.connect ':user/:repo/commits',
      :controller => 'repositories',
      :action => 'commits',
      :conditions => { :method => :get }

  map.connect ':user/:repo/commits/:branch',
      :controller => 'repositories',
      :action => 'commits',
      :conditions => { :method => :get },
      :requirements => {:branch => /[^\/]*/ }

  map.connect ':user/:repo/commits.:format',
      :controller => 'repositories',
      :action => 'commits',
      :conditions => { :method => :get }

  map.connect ':user/:repo/commit/:sha1',
      :controller => 'repositories',
      :action => 'commit',
      :conditions => { :method => :get }

  map.connect ':user/:repo/archive/:branch',
      :controller => 'repositories',
      :action => 'archive',
      :conditions => { :method => :get }

  map.connect ':user/:repo.git/*path',
      :controller => 'repositories',
      :action => 'httpgit',
      :conditions => { :method => :get }

  map.connect ':user/:repo/fork',
      :controller => 'repositories',
      :action => 'fork',
      :conditions => { :method => :get }

  # Default Routes
  #map.connect ':controller/:action/:id'
  #map.connect ':controller/:action/:id.:format'
end
