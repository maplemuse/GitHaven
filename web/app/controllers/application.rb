# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  before_filter :find_user
  layout "site"
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '8c9f143783d5b174c81e7ae0066d30ea'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password

  def index
    @repositories = Repository.find(:all, :limit => 10)
  end

protected
  def find_user
    @user = User.find(session[:user_id])
    if @user.sshkeys.count == 0
      flash[:notice] = "To push to GitForest you need to <a href='#{url_for(:controller => 'sshkeys', :action => 'new')}'>add a ssh key</a>.";
    end
  rescue
    @user = nil
  end

  def require_login
    if @user == nil
        logger.error("This action requires that you be logged in.")
        flash[:notice] = "Not logged in."
        redirect_to :controller => 'users', :action => 'login'
    end
  end


end
